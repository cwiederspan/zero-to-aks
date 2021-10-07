resource "azurerm_user_assigned_identity" "cplane" {
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  name                = "${local.base_name}-cplane-msi"
}

resource "azurerm_user_assigned_identity" "kubelet" {
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  name                = "${local.base_name}-kubelet-msi"
}

resource "azurerm_container_registry" "acr" {
  name                = "${replace(local.base_name, "-", "")}"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  sku                 = "Standard"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = local.base_name
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  dns_prefix          = local.base_name
  kubernetes_version  = var.aks_version

  api_server_authorized_ip_ranges = var.authorized_ip_addresses

  automatic_channel_upgrade = "patch"

  default_node_pool {
    name                 = "lnx000"
    node_count           = var.node_count
    vm_size              = var.node_vm_sku
    orchestrator_version = var.aks_version

    # node_taints
    # node_labels

    # Required for advanced networking
    vnet_subnet_id = azurerm_subnet.cluster.id
  }

  windows_profile {
    admin_username = var.win_admin_username
    admin_password = var.win_admin_password
  }

  identity {
    type                      = "UserAssigned"
    user_assigned_identity_id = azurerm_user_assigned_identity.cplane.id
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.kubelet.client_id
    object_id                 = azurerm_user_assigned_identity.kubelet.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.kubelet.id
  }

#   service_principal {
#     client_id     = module.service_principal.client_id
#     client_secret = module.service_principal.client_secret
#   }

  role_based_access_control {
    enabled = true
    
    azure_active_directory {
      managed                = true
      admin_group_object_ids = [
        var.aks_admin_group_id
      ]
    }
  }
  
  addon_profile {

    # Deprecated as of Kubernetes v1.19+
    # kube_dashboard {
    #   enabled = true
    # }
    
    azure_policy {
      enabled = var.enable_azure_policy
    }

    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = module.monitoring.workspace_id
    }

    # http_application_routing {
    #   enabled = true
    # }
  }

  network_profile {
    network_plugin     = "azure"
    service_cidr       = "172.16.0.0/16"
    dns_service_ip     = "172.16.0.10"
    docker_bridge_cidr = "172.24.0.1/16"

    #network_policy     = "calico"
  }

  # lifecycle {
  #   prevent_destroy = true
  # }

#   depends_on = [
#     module.service_principal.client_id
#   ]
}

# resource "azurerm_kubernetes_cluster_node_pool" "winnodepool" {
#   name                  = "win001"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
#   vm_size               = "Standard_DS2_v2"
#   node_count            = 1
#   os_type               = "Windows"

#   # Required for advanced networking
#   vnet_subnet_id = azurerm_subnet.cluster.id
# }

data "azurerm_container_registry" "acr" {
  resource_group_name  = var.acr_rg_name
  name                 = var.acr_name
}

resource "azurerm_role_assignment" "acrpull_role_kubelet" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_user_assigned_identity.kubelet.principal_id
}

resource "azurerm_role_assignment" "make_aks_kubelet_id_contributor" {
  scope                = azurerm_user_assigned_identity.kubelet.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.cplane.principal_id
}
# Define Kubernetes provider to use the AKS cluster
provider "kubernetes" {
  version = "1.9"
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${local.base_name}-aks"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  dns_prefix          = local.base_name
  kubernetes_version  = var.aks_version

  agent_pool_profile {
    name    = "linux01"
    count   = var.node_count
    vm_size = "Standard_DS2_v2"
    os_type = "Linux"
    type    = "VirtualMachineScaleSets"
  }

  service_principal {
    client_id     = module.service_principal.client_id
    client_secret = module.service_principal.client_secret
  }

  role_based_access_control {
    enabled = true
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = module.monitoring.workspace_id
    }
    # http_application_routing {
    #   enabled = true
    # }
  }

  # lifecycle {
  #   prevent_destroy = true
  # }

  depends_on = [
    module.service_principal.client_id
  ]
}
locals {
  aks_service_name = "${local.base_name}-aks"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${local.aks_service_name}"
  resource_group_name = "${azurerm_resource_group.group.name}"
  location            = "${azurerm_resource_group.group.location}"
  dns_prefix          = "${local.base_name}"
  kubernetes_version  = "${var.aks_version}"

  agent_pool_profile {
    name    = "linux01"
    count   = "${var.node_count}"
    vm_size = "Standard_DS2_v2"
    os_type = "Linux"
    type    = "VirtualMachineScaleSets"
    
    # Required for advanced networking
    vnet_subnet_id = "${azurerm_subnet.cluster.id}"
  }

  service_principal {
    client_id     = "${module.service_principal.client_id}"
    client_secret = "${module.service_principal.client_secret}"
  }

  role_based_access_control {
    enabled = true
  }

  addon_profile {

    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = "${module.monitoring.workspace_id}"
    }

    # http_application_routing {
    #   enabled = true
    # }
  }

  network_profile {
    network_plugin     = "azure"
    service_cidr       = "172.16.0.0/16"
    dns_service_ip     = "172.16.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  # lifecycle {
  #   prevent_destroy = true
  # }

  depends_on = ["module.service_principal"]
}
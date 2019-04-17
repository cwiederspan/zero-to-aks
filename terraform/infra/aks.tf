locals {
  aks_service_name = "${var.name_prefix}-${var.name_base}-${var.name_suffix}"
}


resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${local.aks_service_name}"
  resource_group_name = "${azurerm_resource_group.group.name}"
  location            = "${azurerm_resource_group.group.location}"
  dns_prefix          = "${local.aks_service_name}"
  kubernetes_version  = "${var.aks_version}"

  agent_pool_profile {
    name    = "agentpool"
    count   = "${var.node_count}"
    vm_size = "Standard_DS2_v2"
    os_type = "Linux"
    
    # Required for advanced networking
    vnet_subnet_id = "${azurerm_subnet.cluster.id}"
  }

  service_principal {
    client_id     = "${var.service_principal_name}"
    client_secret = "${var.service_principal_pwd}"
  }

  # role_based_access_control {
  #   enabled = true
  # }

  # addon_profile {
  #   http_application_routing {
  #     enabled = true
  #   }
  # }

  network_profile {
    network_plugin = "azure"
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}
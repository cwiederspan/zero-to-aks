locals {
  aks_service_name = "${var.name_prefix}-${var.name_base}-${var.name_suffix}"
}

# Generate random string to be used as service principal password
resource "random_string" "password" {
  length  = 32
  special = true
}

// Read more about why we're doing this
// https://github.com/terraform-providers/terraform-provider-azurerm/issues/2159

# Create Azure AD Application for Service Principal
resource "azuread_application" "aks" {
  name = "${local.aks_service_name}-sp"
}

# Create Service Principal
resource "azuread_service_principal" "aks" {
  application_id = "${azuread_application.aks.application_id}"
}

# Create Service Principal password
resource "azuread_service_principal_password" "aks" {
  end_date             = "2299-12-30T23:00:00Z"                        # Forever
  service_principal_id = "${azuread_service_principal.aks.id}"
  value                = "${random_string.password.result}"
}

# Assign the Service Principal to the Network Contributor role
resource "azurerm_role_assignment" "aks" {
  principal_id         = "${azuread_service_principal.aks.id}"
  role_definition_name = "Network Contributor"
  scope                = "${azurerm_subnet.cluster.id}"
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

  # service_principal {
  #   client_id     = "${var.service_principal_name}"
  #   client_secret = "${var.service_principal_pwd}"
  # }

  service_principal {
    client_id     = "${azuread_application.aks.application_id}"
    client_secret = "${azuread_service_principal_password.aks.value}"
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
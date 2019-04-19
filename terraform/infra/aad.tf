// Read more about why we're doing this
// https://github.com/terraform-providers/terraform-provider-azurerm/issues/2159

locals {
  sp_application_name = "${var.name_prefix}-${var.name_base}-${var.name_suffix}-sp"
}

# Generate random string to be used as service principal password
resource "random_string" "password" {
  length  = 32
  special = true
}

# Create Azure AD Application for Service Principal
resource "azuread_application" "aks" {
  name = "${local.sp_application_name}"
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
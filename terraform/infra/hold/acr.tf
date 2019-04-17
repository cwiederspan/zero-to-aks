resource "azurerm_container_registry" "acr" {
  name                = "${var.container_registry_name}${var.suffix}"
  resource_group_name = "${azurerm_resource_group.group.name}"
  location            = "${azurerm_resource_group.group.location}"
  admin_enabled       = true
  sku                 = "Basic"
}
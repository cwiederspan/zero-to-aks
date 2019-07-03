
locals {
  resource_group_name = "${local.base_name}"
}

resource "azurerm_resource_group" "group" {
  name     = "${local.resource_group_name}"
  location = "${var.location}"
}
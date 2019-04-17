
locals {
  resource_group_name = "${var.name_prefix}-${var.name_base}-${var.name_suffix}"
}

resource "azurerm_resource_group" "group" {
  name     = "${local.resource_group_name}"
  location = "${var.location}"
}
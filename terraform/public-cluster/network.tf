locals {
  vnet_name           = "${local.base_name}-vnet"

  cluster_subnet_name = "cluster-subnet"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.vnet_name}"
  resource_group_name = "${azurerm_resource_group.group.name}"
  location            = "${azurerm_resource_group.group.location}"
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "cluster" {
  name                 = "${local.cluster_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.group.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.1.0.0/16"
}
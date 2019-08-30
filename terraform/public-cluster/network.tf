locals {
  vnet_name = "${local.base_name}-vnet"

  linux_subnet_name   = "linux-subnet"
  windows_subnet_name = "windows-subnet"
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "linux" {
  name                 = local.linux_subnet_name
  resource_group_name  = azurerm_resource_group.group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.1.0.0/16"
}

resource "azurerm_subnet" "windows" {
  name                 = local.windows_subnet_name
  resource_group_name  = azurerm_resource_group.group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.2.0.0/16"
}
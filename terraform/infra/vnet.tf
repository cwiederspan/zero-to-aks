locals {
  vnet_name           = "${var.name_prefix}-${var.name_base}-${var.name_suffix}-vnet"
  routetable_name     = "${var.name_prefix}-${var.name_base}-${var.name_suffix}-routetable"
  cluster_subnet_name = "cluster-subnet"

  #gateway_subnet_name = "gateway-subnet"
  #gateway_name = 
  #public_ip_name = 
}

resource "azurerm_route_table" "route" {
  name                = "${local.routetable_name}"
  location            = "${azurerm_resource_group.group.location}"
  resource_group_name = "${azurerm_resource_group.group.name}"

  # route {
  #   name                   = "default"
  #   address_prefix         = "10.244.0.0/24"
  #   next_hop_type          = "VirtualAppliance"
  #   next_hop_in_ip_address = "10.240.0.4"
  # }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.vnet_name}"
  resource_group_name = "${azurerm_resource_group.group.name}"
  location            = "${azurerm_resource_group.group.location}"
  address_space       = ["10.0.0.0/8"]
}

# resource "azurerm_subnet" "gateway" {
#   name                 = "${local.gateway_subnet_name}"
#   resource_group_name  = "${azurerm_resource_group.group.name}"
#   virtual_network_name = "${azurerm_virtual_network.vnet.name}"
#   address_prefix       = "10.10.1.0/24"
# }

resource "azurerm_subnet" "cluster" {
  name                 = "${local.cluster_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.group.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.240.0.0/16"
  
  # this field is deprecated and will be removed in 2.0 - but is required until then
  route_table_id = "${azurerm_route_table.route.id}"
}

# resource "azurerm_public_ip" "ip" {
#   name                = "${local.public_ip_name}"
#   resource_group_name = "${azurerm_resource_group.group.name}"
#   location            = "${azurerm_resource_group.group.location}"
#   domain_name_label   = "${local.gateway_name}"
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }
locals {
  vnet_name           = "${local.base_name}-vnet"

  # routetable_name     = "${var.base_name}-routetable"

  gateway_subnet_name = "gateway-subnet"
  ingress_subnet_name = "ingress-subnet"
  bastion_subnet_name = "bastion-subnet"
  cluster_subnet_name = "cluster-subnet"

}

# resource "azurerm_route_table" "route" {
#   name                = "${local.routetable_name}"
#   location            = "${azurerm_resource_group.group.location}"
#   resource_group_name = "${azurerm_resource_group.group.name}"

#   # route {
#   #   name                   = "default"
#   #   address_prefix         = "10.244.0.0/24"
#   #   next_hop_type          = "VirtualAppliance"
#   #   next_hop_in_ip_address = "10.240.0.4"
#   # }
# }

# resource "azurerm_subnet_route_table_association" "test" {
#   subnet_id      = "${azurerm_subnet.cluster.id}"
#   route_table_id = "${azurerm_route_table.route.id}"
# }

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.vnet_name}"
  resource_group_name = "${azurerm_resource_group.group.name}"
  location            = "${azurerm_resource_group.group.location}"
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "gateway" {
  name                 = "${local.gateway_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.group.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "ingress" {
  name                 = "${local.ingress_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.group.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_subnet" "bastion" {
  name                 = "${local.bastion_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.group.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.0.3.0/24"

  delegation {
    name = "aci-subnet-delegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "cluster" {
  name                 = "${local.cluster_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.group.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.1.0.0/16"
}
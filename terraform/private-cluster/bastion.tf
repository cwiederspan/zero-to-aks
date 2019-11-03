# resource "azurerm_container_group" "bastion" {
#   name                = "${local.bastion_name}"
#   resource_group_name = "${azurerm_resource_group.group.name}"
#   location            = "${azurerm_resource_group.group.location}"
#   os_type             = "Linux"
#
#   container {
#     name   = "bastion-utils"
#     image  = "arunvelsriram/utils"
#     cpu    = "0.5"
#     memory = "1.0"
#   }
# }
# resource "null_resource" "bastion" {
# 
#   provisioner "local-exec" {
#     command = "az container create -n ${local.base_name}-aci -g ${azurerm_resource_group.group.name} -l ${azurerm_resource_group.group.location} --image arunvelsriram/utils --vnet ${azurerm_virtual_network.vnet.name} --subnet ${local.bastion_subnet_name} --command-line \"tail -f /dev/null\""
#   }
# }
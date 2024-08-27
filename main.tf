# resource "azurerm_resource_group" "rg01" {
#   name     = var.resource_group_name
#   location = var.location
# }

# resource "azurerm_virtual_network" "main" {
#   name                = azurerm_resource_group.rg01.name
#   address_space       = var.vnet_address_space
#   location            = azurerm_resource_group.rg01.location
#   resource_group_name = azurerm_resource_group.rg01.name
#   depends_on          = [azurerm_resource_group.rg01]
# }

# resource "azurerm_subnet" "internal" {
#   name                 = var.subnet_name
#   resource_group_name  = azurerm_resource_group.rg01.name
#   virtual_network_name = azurerm_virtual_network.main.name
#   address_prefixes     = var.subnet_address_space
#   depends_on           = [azurerm_virtual_network.main]
# }

# module "ubuntu-server" {
#   vm_count         = 1
#   source           = "./Modules/ubuntu20-04_vm"
#   vmname           = var.vm_name
#   rg               = azurerm_resource_group.rg01.name
#   create_rg        = var.create_rg
#   create_vnet      = var.create_vnet
#   vnet             = azurerm_virtual_network.main.name
#   subnet_id        = azurerm_subnet.internal.id
#   create_sshkey    = var.create_sshkey
#   ssh_pub_key_path = var.ssh_pub_key_path
#   depends_on       = [azurerm_subnet.internal]
#   vm_tags          = [{}]
# }

# module "ubuntu-client" {
#   vm_count         = 2
#   source           = "./Modules/ubuntu20-04_vm"
#   vmname           = var.vm_client_name
#   rg               = azurerm_resource_group.rg01.name
#   create_rg        = var.create_rg
#   depends_on       = [azurerm_subnet.internal]
#   create_vnet      = var.create_vnet
#   vnet             = azurerm_virtual_network.main.name
#   subnet_id        = azurerm_subnet.internal.id
#   create_sshkey    = var.create_sshkey
#   ssh_pub_key_path = var.ssh_pub_key_path_cli
#   vm_tags          = var.vm_tags_linux
# }


# module "windows-client" {
#   vm_count    = 1
#   source      = "./Modules/w10_vm"
#   vmname      = var.vm_client_win_name
#   rg          = azurerm_resource_group.rg01.name
#   create_rg   = var.create_rg
#   depends_on  = [azurerm_subnet.internal]
#   create_vnet = var.create_vnet
#   vnet        = azurerm_virtual_network.main.name
#   subnet_id   = azurerm_subnet.internal.id
# }

# module "ws2019_client" {
#   vm_count    = 2
#   source      = "./Modules/ws2019_vm"
#   vmname      = var.ws2019_client_name
#   rg          = azurerm_resource_group.rg01.name
#   create_rg   = var.create_rg
#   depends_on  = [azurerm_subnet.internal]
#   create_vnet = var.create_vnet
#   vnet        = azurerm_virtual_network.main.name
#   subnet_id   = azurerm_subnet.internal.id
#   vm_tags     = var.vm_tags_win
# }
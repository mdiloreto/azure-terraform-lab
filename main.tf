

# module "random_provider" {
#   source = "./Modules/random_provider"
#   max = 9999
#   min = 0

# }

resource "azurerm_resource_group" "rg01" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = azurerm_resource_group.rg01.name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  depends_on          = [azurerm_resource_group.rg01]
}

resource "azurerm_subnet" "internal" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_address_space
  depends_on           = [azurerm_virtual_network.main]
}

module "ubuntu20-04_vm" {
  count            = 1
  source           = "./Modules/ubuntu20-04_vm"
  vmname           = var.vm_name
  rg               = azurerm_resource_group.rg01.name
  create_rg        = "false"
  create_vnet      = "false"
  vnet             = azurerm_virtual_network.main.name
  subnet_id        = azurerm_subnet.internal.id
  create_sshkey    = var.create_sshkey
  ssh_pub_key_path = var.ssh_pub_key_path

  depends_on       = [azurerm_subnet.internal]
}

module "ubuntu20-04_vm-client" {
  count            = 0
  source           = "./Modules/ubuntu20-04_vm"
  vmname           = var.vm_client_name
  rg               = azurerm_resource_group.rg01.name
  create_rg        = "false"
  depends_on       = [azurerm_subnet.internal]
  create_vnet      = "false"
  vnet             = azurerm_virtual_network.main.name
  subnet_id        = azurerm_subnet.internal.id
  create_sshkey    = var.create_sshkey
  ssh_pub_key_path = var.ssh_pub_key_path
}


module "ubuntu20-04_vm-client_win" {
  count            = 0
  source      = "./Modules/w10_vm"
  vmname      = "ans-cli-win10"
  rg          = azurerm_resource_group.rg01.name
  create_rg   = "false"
  depends_on  = [azurerm_subnet.internal]
  create_vnet = "false"
  vnet        = azurerm_virtual_network.main.name
  subnet_id   = azurerm_subnet.internal.id
}
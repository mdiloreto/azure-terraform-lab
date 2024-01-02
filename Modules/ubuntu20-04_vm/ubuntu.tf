
resource "azurerm_resource_group" "madsblog" {
  count    = var.create_rg ? 1 : 0  # Create RG if var.create_rg is true
  name     = var.rg
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  count    = var.create_vnet ? 1 : 0  # Create RG if var.create_rg is true
  
  name                = "${var.vmname}${count.index + 1}-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg
}

resource "azurerm_subnet" "internal" {
  count    = var.create_vnet ? 1 : 0  # Create RG if var.create_rg is true

  name                 = var.subnet_name
  resource_group_name  = var.rg
  virtual_network_name = var.vnet
  address_prefixes     = ["10.0.2.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  count               = var.vm_count

  name                = "${var.vmname}${count.index + 1}-public-ip"
  location            = var.location
  resource_group_name = var.rg
  sku = "Basic"
  allocation_method   = "Dynamic"
  sku_tier = "Regional"
  ip_version = "IPv4"
}

resource "azurerm_network_interface" "vmnic01" {
  count               = var.vm_count
  name                = "${var.vmname}${count.index + 1}-nic01"
  location            = var.location
  resource_group_name = var.rg

   ip_configuration {
    name                          = "${var.vmname}${count.index + 1}-nicconfiguration1"
    subnet_id = var.create_vnet ? azurerm_subnet.internal[count.index].id : var.subnet_id
    private_ip_address_allocation = "Static"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip[count.index].id

  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count 

  resource_group_name             = var.rg
  location                        = var.location
  name                            = "${var.vmname}${count.index + 1}"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  tags                            = var.vm_tags[count.index]
  size                            = "Standard_B2s"

  network_interface_ids = [
      azurerm_network_interface.vmnic01[count.index].id,
  ]

  admin_ssh_key{
    username = var.admin_username
    public_key = var.create_sshkey ? file(var.ssh_pub_key_path) : ""
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    caching                   = "ReadWrite"
    storage_account_type      = "Standard_LRS"
      disk_size_gb              = 40
      name                      = "${var.vmname}${count.index + 1}-disk"
      write_accelerator_enabled = false
  }

}
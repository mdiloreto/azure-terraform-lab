
resource "azurerm_resource_group" "madsblog" {
  count    = var.create_rg ? 1 : 0  # Create RG if var.create_rg is true
  name     = var.rg
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.vmname}-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg
  count    = var.create_vnet ? 1 : 0  # Create RG if var.create_rg is true

}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = var.rg
  virtual_network_name = var.vnet
  address_prefixes     = ["10.0.2.0/24"]
  count    = var.create_vnet ? 1 : 0  # Create RG if var.create_rg is true

}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "${var.vmname}-public-ip"
  location            = var.location
  resource_group_name = var.rg
  sku = "Basic"
  allocation_method   = "Dynamic"
  sku_tier = "Regional"
  ip_version = "IPv4"
}

resource "azurerm_network_interface" "vmnic01" {
  name                = "${var.vmname}-nic01"
  location            = var.location
  resource_group_name = var.rg

   ip_configuration {
    name                          = "${var.vmname}-nicconfiguration1"
    subnet_id = var.create_vnet ? azurerm_subnet.internal[1].id : var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id

  }
}

resource "azurerm_virtual_machine" "vm" {
  
  location = var.location
  name = var.vmname
  network_interface_ids = [
      azurerm_network_interface.vmnic01.id,
  ]
  resource_group_name   = var.rg
  tags                  = {}
  vm_size               = "Standard_B2s"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  
  os_profile {
    computer_name = var.vmname
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false

    ssh_keys {
    path     = "/home/${var.admin_username}/.ssh/authorized_keys"
    key_data = var.create_sshkey ? file(var.ssh_pub_key_path) : ""
  }
  }
  
  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  storage_os_disk {
      caching                   = "ReadWrite"
      create_option             = "FromImage"
      disk_size_gb              = 127
      managed_disk_type         = "Premium_LRS"
      name                      = "${var.vmname}-disk"
      os_type                   = "Linux"
      write_accelerator_enabled = false
  }
}
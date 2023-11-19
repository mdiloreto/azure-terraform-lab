resource "azurerm_resource_group" "madsblog-rg" {
  name     = var.rg
  location = var.location
  count    = var.create_rg ? 1 : 0  # Create RG if var.create_rg is true

}

resource "azurerm_virtual_network" "main" {
  name                = var.vnet
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

resource "azurerm_network_interface" "w10_vmnic" {
  count                  = var.vm_count
  
  name                = "${var.vmname}${count.index + 1}-nic"
  location            = var.location
  resource_group_name = var.rg

  ip_configuration {
    name                          = "${var.vmname}${count.index + 1}-nicconfiguration1"
    subnet_id = var.create_vnet ? azurerm_subnet.internal[count.index].id : var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  count               = var.vm_count 

  resource_group_name             = var.rg
  location                        = var.location
  name                            = "${var.vmname}${count.index + 1}"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  tags                            = {}
  size               = "Standard_B2s"
  
  network_interface_ids = [
      azurerm_network_interface.w10_vmnic[count.index].id,
  ]

  
  source_image_reference {
    offer     = "Windows-10"
    publisher = "MicrosoftWindowsDesktop"
    sku       = "win10-22h2-pro-g2"
    version   = "latest"
  }

  os_disk {
    caching                   = "ReadWrite"
    storage_account_type      = "Standard_LRS"
      disk_size_gb              = 127
      name                      = "${var.vmname}${count.index + 1}-disk"
      write_accelerator_enabled = false
  }
}
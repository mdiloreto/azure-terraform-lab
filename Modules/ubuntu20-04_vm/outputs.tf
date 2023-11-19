output "resource_group_name" {
  value = azurerm_resource_group.madsblog[*].name
}

output "vnet_name" {
  value = azurerm_virtual_network.main[*].name
}

output "ubuntu_server_modules_vmnames" {
  value = azurerm_linux_virtual_machine.vm[*].name
}

output "vm_public_ip" {
  value = azurerm_public_ip.my_terraform_public_ip[*].ip_address
  description = "The public IP address of the VM."
}



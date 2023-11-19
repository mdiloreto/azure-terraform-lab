output "resource_group_name" {
  value = azurerm_resource_group.rg01.name
}

output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "Ubuntu_server_modules_vmnames" {
  value = module.ubuntu-server[*].ubuntu_server_modules_vmnames
}

output "vm_public_ip_addresses" {
  value = module.ubuntu-server[*].vm_public_ip
  description = "Public IP addresses of the deployed VMs."
}

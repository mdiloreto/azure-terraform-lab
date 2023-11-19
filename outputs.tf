## Resource Group anb vnet global outputs <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
output "resource_group_name" {
  value = azurerm_resource_group.rg01.name
}

output "vnet_name" {
  value = azurerm_virtual_network.main.name
}
## Ubuntu server outputs <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
output "ubuntu_server_modules_vmnames" {
  value = module.ubuntu-server[*].ubuntu_server_modules_vmnames
}

output "ubuntu-server_vm_public_ip_addresses" {
  value = module.ubuntu-server[*].vm_public_ip
  description = "Public IP addresses of the deployed VMs."
}

## Ubuntu client outputs <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

output "ubuntu_client_modules_vmnames" {
  value = module.ubuntu-client[*].ubuntu_server_modules_vmnames
}

output "ubuntu-client_vm_public_ip_addresses" {
  value = module.ubuntu-client[*].vm_public_ip
  description = "Public IP addresses of the deployed VMs."
}

## Windows client outputs <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

output "windows_client_modules_vmnames" {
  value = module.windows-client[*].ubuntu_server_modules_vmnames
}

output "windows_vm_public_ip_addresses" {
  value = module.windows-client[*].vm_public_ip
  description = "Public IP addresses of the deployed VMs."
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_space" {
  description = "The address prefixes for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "vm_name" {
  description = "The name of the VM"
  type        = string
  default     = "madsblog-vm"
}

variable "create_rg" {
  description = "The variable to create the RG that is created within the module. If you created it as a resource outside the module. Set to false."
  type = bool
  default = false
}

variable "create_vnet" {
  description = "The variable to create the VNET that is created within the module. If you created it as a resource outside the module. Set to false."
  type = bool
  default = false
}


variable "create_sshkey" {
  description = "Do you want the VM to use SSH key? yes (true) or no (false)"
  type        = bool
  default     = false
}

variable "ssh_pub_key_path" {
  description = "The path to the public SSH key"
  type        = string
}

variable "subnet_name" {
  description = "The subnet name"
  default     = "internal"
}

variable "vm_client_name" {
  description = "The name of the client VM"
  type        = string
  default     = "madsblog-cli"
}

variable "vm_client_win_name" {
  description = "The name of the Windows client VM"
  type        = string
  default     = "mb-win-cli"
}


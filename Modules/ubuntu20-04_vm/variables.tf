variable "rg" {
  default = "ubuntu-rg"
}

variable "vm_count" {
  description = "The number of virtual machines to create"
  type        = number
  default = 1
}

variable "vmname" {
  default = "ubuntuvm"
}

variable "location" {
  default = "eastus"
}

variable "admin_username" {
  default = "admin_user01"
  sensitive = true
}

variable "admin_password" {
  default = "MadsBlog_2023!!"
  sensitive = true
}

variable "ssh_pub_key_path" {
  description = "Path to the SSH public key"
  default     = "C:/Users/mdiloreto/OneDrive - Wezen Group/VSCODE/PrivateKeys/Ansible_VMs_azure.pub"
  sensitive = true
}

variable "create_sshkey" {
  description = "Whether to create a new resource group or use an existing one"
  type        = bool
  default = "true"
} 

variable "create_rg" {
  description = "Variable to set to $true if you want to create a SSH Key"
  type        = bool
  default     = false  # Default behavior is to create a new RG
}

variable "vnet" {
  default = "default-vm-vnet"
}

variable "create_vnet" {
  description = "Whether to create a new resource group or use an existing one"
  type        = bool
  default = "true"
}

variable "subnet_name" {
  description = "the subnet name"
  default = "internal"
}

variable "subnet_id" {
  description = "The ID of the subnet where the VM should be placed"
  type        = string
}


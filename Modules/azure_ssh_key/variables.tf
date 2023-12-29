variable "create_rg" {
  description = "Variable to set to $true if you want to create a SSH Key"
  type        = bool
  default     = false  # Default behavior is to create a new RG
}

variable "rg" {
  default = "ubuntu-rg"
}

variable "vm_count" {
  description = "The number of virtual machines to create"
  type        = number
  default = 1
}

variable "location" {
  default = "eastus"
}

variable "ssh_pub_key_file" {
  description = "Path to the SSH public key"
  default     = "C:/Users/mdiloreto/OneDrive - Wezen Group/VSCODE/PrivateKeys/Ansible_VMs_azure.pub"
  sensitive = true
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "tfstate"
      storage_account_name = "tfstate1953629526"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }

}

provider "azurerm" {
  features {
    # resource_group {
  #  prevent_deletion_if_contains_resources = false
    # }
  }
}

# Configure the Azure Active Directory Provider
provider "azuread" {
  tenant_id = "88940f07-5551-49e6-8453-c578e8759aaf"
}

# module "random_provider" {
#   source = "./Modules/random_provider"
#   max = 9999
#   min = 0

# }

resource "azurerm_resource_group" "rg01" {
  name = "ansible-test"
  location = "eastus"
}

resource "azurerm_virtual_network" "main" {
  name                = azurerm_resource_group.rg01.name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  depends_on = [ azurerm_resource_group.rg01 ]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [ azurerm_virtual_network.main ]
}

module "ubuntu20-04_vm" {
  source = "./Modules/ubuntu20-04_vm"
  vmname = "ansible"
  rg = azurerm_resource_group.rg01.name
  create_rg = "false"
  create_vnet = "false"
  depends_on = [azurerm_subnet.internal]
  vnet = azurerm_virtual_network.main.name
  subnet_id = azurerm_subnet.internal.id
  create_sshkey = true
  ssh_pub_key_path = "C:/Users/mdiloreto/OneDrive - Wezen Group/VSCODE/PrivateKeys/Ansible_VMs_azure.pub"
}

module "ubuntu20-04_vm-client" {
  source = "./Modules/ubuntu20-04_vm"
  vmname = "ansible-client"
  rg = azurerm_resource_group.rg01.name
  create_rg = "false" 
  depends_on = [azurerm_subnet.internal]
  create_vnet = "false"
  vnet = azurerm_virtual_network.main.name
  subnet_id = azurerm_subnet.internal.id
  create_sshkey = true
  ssh_pub_key_path = "C:/Users/mdiloreto/OneDrive - Wezen Group/VSCODE/PrivateKeys/Ansible_VMs_azure.pub"
}

module "ubuntu20-04_vm-client2" {
  source = "./Modules/ubuntu20-04_vm"
  vmname = "ansible-cli2"
  rg = azurerm_resource_group.rg01.name
  create_rg = "false" 
  depends_on = [azurerm_subnet.internal]
  create_vnet = "false"
  vnet = azurerm_virtual_network.main.name
  subnet_id = azurerm_subnet.internal.id
  create_sshkey = true
  ssh_pub_key_path = "C:/Users/mdiloreto/OneDrive - Wezen Group/VSCODE/PrivateKeys/Ansible_VMs_azure.pub"
}

module "ubuntu20-04_vm-client3" {
  source = "./Modules/ubuntu20-04_vm"
  vmname = "ansible-cli3"
  rg = azurerm_resource_group.rg01.name
  create_rg = "false" 
  depends_on = [azurerm_subnet.internal]
  create_vnet = "false"
  vnet = azurerm_virtual_network.main.name
  subnet_id = azurerm_subnet.internal.id
  create_sshkey = true
  ssh_pub_key_path = "C:/Users/mdiloreto/OneDrive - Wezen Group/VSCODE/PrivateKeys/Ansible_VMs_azure.pub"
}

module "ubuntu20-04_vm-client_win" {
  source = "./Modules/w10_vm"
  vmname = "ans-cli-win10"
  rg = azurerm_resource_group.rg01.name
  create_rg = "false" 
  depends_on = [azurerm_subnet.internal]
  create_vnet = "false"
  vnet = azurerm_virtual_network.main.name
  subnet_id = azurerm_subnet.internal.id
}
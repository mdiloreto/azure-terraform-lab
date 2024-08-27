terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.116.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.15.0"
    }
  }
}

provider "azurerm" {
  features {}
  # resource_group {
  #  prevent_deletion_if_contains_resources = false
  # } 
  #alias           = "mpn" # can not have an alias if its the default provider
  subscription_id = "4c0caea8-7d62-4ae6-8384-2f999ac43380"
  tenant_id       = "5af93c07-6c6e-4b5f-93cf-ef1952c98abf"

}

# Configure the Azure Active Directory Provider
provider "azuread" {
  tenant_id = "5af93c07-6c6e-4b5f-93cf-ef1952c98abf"
}

# provider azurerm {
# features {}
# }
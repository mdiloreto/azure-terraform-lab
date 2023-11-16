terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.15.0"
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
  features {}
  # resource_group {
  #  prevent_deletion_if_contains_resources = false
  # } 
  #alias           = "mpn" # can not have an alias if its the default provider
  subscription_id = "f64ded84-0267-4150-b30c-a1f7ed8abe5f"
  tenant_id       = "88940f07-5551-49e6-8453-c578e8759aaf"
}

# Configure the Azure Active Directory Provider
provider "azuread" {
  tenant_id = "88940f07-5551-49e6-8453-c578e8759aaf"
}

# provider azurerm {
# features {}
# }
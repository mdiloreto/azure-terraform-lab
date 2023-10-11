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

module "random_provider" {

  source = "./Modules/random_provider"
  max = 9999
  min = 0

}

module "functions" {
  source = "./Modules/Functions"
  functionapp_name = "functionapp${module.random_provider.random_value}"
  functionapp_rg_name = "functionapp${module.random_provider.random_value}-rg"
  functionapp_sa_name = "functionapp${module.random_provider.random_value}sa"
  azure_functions_asp_name = "functionapp${module.random_provider.random_value}asp"
}
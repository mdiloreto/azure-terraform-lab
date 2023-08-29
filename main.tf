terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
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
}

#Resource Group de Ejemplo

resource "azurerm_resource_group" "state-demo-secure" {
  name     = "state-demo"
  location = "eastus"
}

#START> Function App Python 3.10 con Consumption plan <

resource "azurerm_resource_group" "functionapp-py-consumption-rg" {
  name     = var.functionapp_rg_name
  location = "East US 2"
}

resource "azurerm_storage_account" "functionapp-py-consumption-sa" {
  name                     = var.functionapp_sa_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "functionapp-py-consumption-asp" {
  name                = var.azure_functions_asp_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  lifecycle {
    ignore_changes = [
      kind
    ]
  }
}

resource "azurerm_function_app" "functionapp-py-consumption-fa" {
  name                       = var.functionapp_name
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  app_service_plan_id        = azurerm_app_service_plan.example.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  os_type                    = "linux"
  version                    = "~4"



  app_settings {
    FUNCTIONS_WORKER_RUNTIME = "python"
  }

  site_config {
    linux_fx_version = "python|3.10"
  }
}

#END> Function App Python 3.10 con Consumption plan <
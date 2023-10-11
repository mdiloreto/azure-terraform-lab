resource "azurerm_resource_group" "functionapp-py-consumption-rg" {
  name     = var.functionapp_rg_name
  location = "East US 2"
}

resource "azurerm_storage_account" "functionapp-py-consumption-sa" {
  name                     = var.functionapp_sa_name
  resource_group_name      = azurerm_resource_group.functionapp-py-consumption-rg.name
  location                 = azurerm_resource_group.functionapp-py-consumption-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# azurerm_app_service_plan fue deprecado y sustituido por azurerm_service_plan 

# resource "azurerm_app_service_plan" "functionapp-py-consumption-asp" {
#   name                = var.azure_functions_asp_name
#   location            = azurerm_resource_group.functionapp-py-consumption-rg.location
#   resource_group_name = azurerm_resource_group.functionapp-py-consumption-rg.name
#   kind                = "Linux"
#   reserved            = true

#   sku {
#     tier = "Dynamic"
#     size = "Y1"
#   }

#   lifecycle {
#     ignore_changes = [
#       kind
#     ]
#   }
# }

resource "azurerm_service_plan" "functionapp-py-consumption-asp" {
  name                = var.azure_functions_asp_name
  resource_group_name = azurerm_resource_group.functionapp-py-consumption-rg.name
  location            = azurerm_resource_group.functionapp-py-consumption-rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_function_app" "functionapp-py-consumption-fa" {
  name                = var.functionapp_name
  resource_group_name = azurerm_resource_group.functionapp-py-consumption-rg.name
  location            = azurerm_resource_group.functionapp-py-consumption-rg.location

  storage_account_name       = azurerm_storage_account.functionapp-py-consumption-sa.name
  storage_account_access_key = azurerm_storage_account.functionapp-py-consumption-sa.primary_access_key
  service_plan_id            = azurerm_service_plan.functionapp-py-consumption-asp.id

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
  }

  site_config {

    application_stack {
      python_version = "3.10"
    }  
    cors {
      allowed_origins = [
        "https://portal.azure.com",
      ]
      support_credentials = false
    }  
  
  }
}

#azurerm_function_app fue deprecado y sustituido por azurerm_linux_function_app y azurerm_windows_function_app 

# resource "azurerm_function_app" "functionapp-py-consumption-fa" {
#   name                       = var.functionapp_name
#   location                   = azurerm_resource_group.functionapp-py-consumption-rg.location
#   resource_group_name        = azurerm_resource_group.functionapp-py-consumption-rg.name
#   app_service_plan_id        = azurerm_service_plan.functionapp-py-consumption-asp.id
#   storage_account_name       = azurerm_storage_account.functionapp-py-consumption-sa.name
#   storage_account_access_key = azurerm_storage_account.functionapp-py-consumption-sa.primary_access_key
#   os_type                    = "linux"
#   version                    = "~4"

#   app_settings = {
#     FUNCTIONS_WORKER_RUNTIME = "python"
#   }

#   site_config {
#     linux_fx_version = "python|3.10"
#   }
# }

#END > Function App Python 3.10 con Consumption plan <
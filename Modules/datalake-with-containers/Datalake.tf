
####START >Datalake<
resource "azurerm_resource_group" "DataLake_lab" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "DataLake_lab-sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.DataLake_lab.name
  location                 = azurerm_resource_group.DataLake_lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  depends_on = azurerm_resource_group.DataLake_lab
}

resource "azurerm_storage_container" "bronze" {
  name                  = "bronze"
  storage_account_name  = azurerm_storage_account.DataLake_lab-sa.name
  container_access_type = "private"
  depends_on = [ azurerm_storage_account.DataLake_lab-sa ]
}

# resource "azurerm_role_assignment" "role_assignment" {
#   principal_id   = "5e193d65-8a83-453f-a1ef-393e94e25053"
#   role_definition_name = "Storage Blob Data Contributor"
#   scope          = azurerm_storage_account.DataLake_lab-sa.id
# }


resource "azurerm_storage_data_lake_gen2_filesystem" "fileSystem01" {
  name               = "gold"
  storage_account_id = azurerm_storage_account.DataLake_lab-sa.id

  properties = {
    hello = "aGVsbG8="
  }
}

resource "azurerm_storage_data_lake_gen2_path" "directory01" {
  path               = "root/sub01/sub02"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.fileSystem01.name
  storage_account_id = azurerm_storage_account.DataLake_lab-sa.id
  resource           = "directory"
}

resource "azurerm_storage_data_lake_gen2_path" "directory02" {
  path               = "root/sub21/sub22"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.fileSystem01.name
  storage_account_id = azurerm_storage_account.DataLake_lab-sa.id
  resource           = "directory"
}

resource "azurerm_storage_data_lake_gen2_path" "directory03" {
  path               = "root2/sub01/sub02"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.fileSystem01.name
  storage_account_id = azurerm_storage_account.DataLake_lab-sa.id
  resource           = "directory"
}
###END >Datalake<
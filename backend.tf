### tdiloreto MPN subscription

### Create Storage account: 
// az storage account create --name tfstate34523847 --resource-group tfstate --location eastus --sku Standard_LRS --kind StorageV2

# terraform {

#   backend "azurerm" {
#     resource_group_name  = "tfstate"
#     storage_account_name = "tfstate1953629526"
#     container_name       = "tfstate"
#     key                  = "terraform.tfstate"
#   }
# }

terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate34523847"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
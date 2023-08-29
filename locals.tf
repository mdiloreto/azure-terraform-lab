locals {
  functionapp_name = "functionapp${random_integer.ri.result}"
  functionapp_rg_name = "functionapp-rg-${random_integer.ri.result}"
  functionapp_sa_name = "functionapp${random_integer.ri.result}sa"
  azure_functions_asp_name = "functionapp-asp-${random_integer.ri.result}"
}

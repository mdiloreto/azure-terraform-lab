provider "random" {}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}
# variable "functionapp_name" {
#   description = "Nombre de la function app"
#   type        = string
#   default     = "functionapp${random_integer.ri.result}"
# }

# variable "functionapp_rg_name" {
#   description = "Nombre de function app Resource Group"
#   type        = string
#   default     = "functionapp-rg-${random_integer.ri.result}"
# }
# variable "functionapp_sa_name" {
#   description = "Nombre de la function app Storage Account"
#   type        = string
#   default     = "functionapp-sa-${random_integer.ri.result}"
# }

# variable "azure_functions_asp_name" {
#   description = "Nombre de la function App Service Plan"
#   type        = string
#   default     = "functionapp-asp-${random_integer.ri.result}"
# }
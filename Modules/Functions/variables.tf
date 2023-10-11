variable "functionapp_name" {
  description = "Nombre de la function app"
  type        = string
  default     = "functionappmadsblog10000"
}

variable "functionapp_rg_name" {
  description = "Nombre de function app Resource Group"
  type        = string
  default     = "functionapp-rg-madsblog10000"
}
variable "functionapp_sa_name" {
  description = "Nombre de la function app Storage Account"
  type        = string
  default     = "functionappsamadsblog10000"
}

variable "azure_functions_asp_name" {
  description = "Nombre de la function App Service Plan"
  type        = string
  default     = "functionappaspmadsblog10000"
}
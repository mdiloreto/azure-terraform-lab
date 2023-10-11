# Configure the Azure Active Directory Provider
provider "azuread" {
  tenant_id = var.tenant_id
}

resource "azuread_user" "example" {
  count               = var.usercount
  user_principal_name = "${var.user_prefix}user${count.index + 1}@${var.usersdomain}"
  display_name        = "User ${count.index + 1}"
  password            = var.password
}
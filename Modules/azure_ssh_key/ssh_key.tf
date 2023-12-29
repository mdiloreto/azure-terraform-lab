
resource "azurerm_resource_group" "madsblog" {
  count    = var.create_rg ? 1 : 0  # Create RG if var.create_rg is true
  name     = var.rg
  location = var.location
}

resource "azurerm_ssh_public_key" "ssh_key" {
  name                = "ssh_key"
  resource_group_name = var.rg
  location            = var.location
  public_key          = file("${var.ssh_pub_key_file}")
}
resource "azurerm_public_ip" "this" {
  name                = var.ip_name
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"

}
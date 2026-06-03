resource "azurerm_bastion_host" "this" {
  name                = var.bs_name
  location            = var.location
  resource_group_name = var.rg_name
  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.snet_id
    public_ip_address_id = var.pip_id
  }
}
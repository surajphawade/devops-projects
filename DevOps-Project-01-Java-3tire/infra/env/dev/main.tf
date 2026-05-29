# 1. Resource Group Module
module "azurerm_resource_group" {
  source   = "../../module/azurerm_resource_group"
  rg_name  = var.rg_name
  location = var.location
  rg_tags  = var.rg_tags
}

# 2. Storage Account Module
module "azurerm_storage_account" {
  source                   = "../../module/azurerm_storage_account"
  stg_name                 = var.stg_name
  resource_group_name      = module.azurerm_resource_group.rg_name
  location                 = module.azurerm_resource_group.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  stg_tags                 = var.stg_tags
}

# 3. Storage Container Module
module "azurerm_storage_container" {
  source               = "../../module/azurerm_storage_container"
  container_name       = var.container_name
  storage_account_name = module.azurerm_storage_account.stg_account_name
}

# 4. Virtual Network Module
module "azurerm_virtual_network" {
  for_each = var.vnets
  source        = "../../module/azurerm_virtual_network"
  vnet_name     = each.key
  rg_name       = module.azurerm_resource_group.rg_name
  location      = module.azurerm_resource_group.location
  address_space = each.value.vnet_address_space
  vnet_tags     = each.value.vnet_tags
}

# 5. Subnet Module

module "azurerm_subnet" {
  for_each = var.snets
  source = "../../module/azurerm_subnet"

  subnet_name = each.key
  rg_name =   module.azurerm_resource_group.rg_name
  vnet_name = module.azurerm_virtual_network[each.value.vnet_name].vnet_name

  address_prefixes = each.value.address_prefixes
}
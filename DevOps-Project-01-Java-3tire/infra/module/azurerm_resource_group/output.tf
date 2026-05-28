output "rg_name" {
  value       = azurerm_resource_group.this.name
  description = "resource group name"
}

output "location" {
  value = azurerm_resource_group.this.location
}
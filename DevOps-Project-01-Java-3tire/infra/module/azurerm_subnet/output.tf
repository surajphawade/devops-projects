output "subnet_id" {
  value       = azurerm_subnet.this.id
  description = "The ID of the created subnet"
}

output "subnet_name" {
  value       = azurerm_subnet.this.name
  description = "The Name of the created subnet"
}
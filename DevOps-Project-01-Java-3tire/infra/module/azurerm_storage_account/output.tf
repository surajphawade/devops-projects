output "stg_account_name" {
  value       = azurerm_storage_account.this.name
  description = "The name of the created storage account"
}
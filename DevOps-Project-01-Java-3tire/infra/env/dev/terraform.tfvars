# Resource Group Values
rg_name  = "dev-az-3-tire-rg"
location = "eastus2"
rg_tags  = {
  Environment = "Dev"
  ManagedBy   = "Terraform"
  Project     = "Java-3Tire"
}

# Storage Account Values
stg_name                 = "stdevjavatire01" # Must be globally unique & lowercase
account_tier             = "Standard"
account_replication_type = "LRS"
stg_tags                 = {
  Environment = "Dev"
  Component   = "Storage"
}

# Storage Container Values
container_name = "app-assets"
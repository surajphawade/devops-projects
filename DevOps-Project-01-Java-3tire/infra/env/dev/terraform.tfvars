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
container_name = "dev-cntnr"

# Virtual Network Values
vnet_name          = "dev-az-3-tire-vnet"
vnet_address_space = ["10.10.0.0/16","172.0.0.0/16"]
vnet_tags = {
  Environment = "Dev"
  Component   = "Networking"
}
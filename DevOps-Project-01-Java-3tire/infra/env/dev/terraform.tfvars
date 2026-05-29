# Resource Group Values
rg_name  = "dev-az-3-tire-rg"
location = "eastus2"
rg_tags = {
  Environment = "Dev"
  ManagedBy   = "Terraform"
  Project     = "Java-3Tire"
}

# Storage Account Values
stg_name                 = "stdevjavatire01" # Must be globally unique & lowercase
account_tier             = "Standard"
account_replication_type = "LRS"
stg_tags = {
  Environment = "Dev"
  Component   = "Storage"
}

# Storage Container Values
container_name = "dev-cntnr"

# Virtual Network Values
vnets = {
  hub_vnet = {
    vnet_address_space = ["10.10.0.0/16", "172.0.0.0/16"]
    vnet_tags = {
       Environment = "Dev"
      Component   = "Networking"
    }
  }
  spoke_vnet = {
    vnet_address_space = ["10.11.0.0/16", "172.1.0.0/16"]
    vnet_tags = {
       Environment = "Dev"
      Component   = "Networking"
    }
  }
}


# vnet_name          = "dev-az-3-tire-vnet"
# vnet_address_space = ["10.10.0.0/16", "172.0.0.0/16"]
# vnet_tags = {
#   Environment = "Dev"
#   Component   = "Networking"
# }

# --- Subnet Configuration ---
# subnet_name             = "dev-subnet-01"
# subnet_address_prefixes = ["10.0.1.0/24"]

snets = {
  front_snet = {
    vnet_name         = "hub_vnet"
    address_prefixes = ["10.10.4.0/24"]
  }
  back_snet = {
    vnet_name         = "hub_vnet"
    address_prefixes = ["172.0.4.0/24"]
  }
}

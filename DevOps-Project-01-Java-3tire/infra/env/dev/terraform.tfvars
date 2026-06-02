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
  spoke_vnet = {
    vnet_name = "spoke_vnet"
    vnet_address_space = ["10.10.0.0/16", "172.16.0.0/16"]
    vnet_tags = {
      Environment = "Dev"
      Component   = "Networking"
    }
  }
  hub_vnet = {
    vnet_name = "hub_vnet"
    vnet_address_space = ["10.11.0.0/16", "172.17.0.0/16"]
    vnet_tags = {
      Environment = "Dev"
      Component   = "Networking"
    }
  }
}

# Subnet Values
snets = {
  front_snet = {
    snet_name = "frontend_snet"
    vnet_name        = "spoke_vnet"
    address_prefixes = ["10.10.4.0/24"]
  }
  front_snet2 = {
    snet_name = "front_snet"
    vnet_name        = "spoke_vnet"
    address_prefixes = ["10.10.5.0/24"]
  }
  lb_snet = {
    snet_name = "ILB_snet"
    vnet_name        = "spoke_vnet"
    address_prefixes = ["10.10.6.0/24"]
  }
  back_snet = {
    snet_name = "backend_snet"
    vnet_name        = "spoke_vnet"
    address_prefixes = ["10.10.7.0/24"]
  }
  back_snet2 = {
    snet_name = "back_snet"
    vnet_name        = "spoke_vnet"
    address_prefixes = ["10.10.8.0/24"]
  }

  bs_snet = {
    snet_name = "AzureBastionSubnet"
    vnet_name        = "hub_vnet"
    address_prefixes = ["10.11.5.0/24"]
  }
  
}

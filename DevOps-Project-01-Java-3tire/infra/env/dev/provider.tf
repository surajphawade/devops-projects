terraform {
  required_providers {
    azurerm = {
        source = "hasicorp/azaurerm"
        version = "~> 4.0"
    }
  }
#   backend "azurerm" {
#     resource_group_name = "value"
#     storage_account_name = "value"
#     container_name = "value"
#     key = "value"
#   }
}
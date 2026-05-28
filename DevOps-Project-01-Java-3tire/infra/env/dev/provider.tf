terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
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

provider "azurerm" {
  features {

  }
  subscription_id = "2cd4b0da-b78f-45de-af90-bb7b78de22fc"

}

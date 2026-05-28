variable "stg_name" {
  type        = string
  description = "The name of the storage account (must be globally unique and lowercase)"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the storage account"
}

variable "location" {
  type        = string
  description = "The Azure region where the storage account should exist"
}

variable "account_tier" {
  type        = string
  description = "Defines the Tier to use for this storage account (Standard or Premium)"
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account"
  default     = "LRS"
}

variable "stg_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}
# --- Resource Group Variables ---
variable "rg_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region for deployment"
}

variable "rg_tags" {
  type        = map(string)
  description = "Tags for the resource group"
}

# --- Storage Account Variables ---
variable "stg_name" {
  type        = string
  description = "Globally unique, lowercase name for the storage account"
}

variable "account_tier" {
  type        = string
  description = "Storage Tier (Standard or Premium)"
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Replication strategy (LRS, GRS, etc.)"
  default     = "LRS"
}

variable "stg_tags" {
  type        = map(string)
  description = "Tags for the storage account"
  default     = {}
}

# --- Storage Container Variables ---
variable "container_name" {
  type        = string
  description = "Name of the storage container"
}

# --- Virtual Network Variables ---
variable "vnet_name" {
  type        = string
  description = "Name of the VNet"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space range for the dev VNet"
}

variable "vnet_tags" {
  type        = map(string)
  description = "Tags for the virtual network"
}
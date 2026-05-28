variable "vnet_name" {
  type        = string
  description = "The name of the virtual network"
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "The Azure region where the virtual network will be created"
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network"
}

variable "vnet_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
}
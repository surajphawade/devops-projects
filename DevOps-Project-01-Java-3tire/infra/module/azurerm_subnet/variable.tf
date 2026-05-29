variable "subnet_name" {
  type        = string
  description = "The name of the subnet"
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group"
}

variable "vnet_name" {
  type        = string
  description = "The name of the virtual network"
}

variable "address_prefixes" {
  type        = list(string)
  description = "The address prefixes for the subnet"
}


variable "rg_name" {
  type        = string
  description = "resource group name"
}

variable "location" {
  type        = string
  description = "resource group location"
}

variable "rg_tags" {
  type        = map(string)
  description = "resource group tags"
}
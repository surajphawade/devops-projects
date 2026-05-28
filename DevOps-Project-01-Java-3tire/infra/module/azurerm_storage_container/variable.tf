variable "container_name" {
  type        = string
  description = "The name of the Storage Container"
}

variable "storage_account_name" {
  type        = string
  description = "The name of the Storage Account where the Container should be created"
}

variable "container_access_type" {
  type        = string
  description = "The Access Level configured for this Storage Container (private, blob, or container)"
  default     = "private"
}
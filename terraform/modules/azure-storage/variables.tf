variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the storage account will be created"
  type        = string
}

variable "location" {
  description = "The Azure region where the storage account will be created"
  type        = string
}

variable "account_tier" {
  description = "The performance tier of the storage account (e.g., Standard, Premium)"
  type        = string
}

variable "access_tier" {
  description = "The access tier of the storage, so how frequently and fast you need the data (e.g. Hot, Cool)"
  type        = string
}

variable "account_replication_type" {
  description = "The replication strategy for the storage account (e.g., LRS, GRS)"
  type        = string
}

variable "container_names" {
  description = "The containers created inside of the storage accounts (list of values for multiple containers)."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to assign to the storage account"
  type        = map(string)
  default     = {}
}
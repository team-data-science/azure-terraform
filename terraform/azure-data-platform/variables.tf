# Variables for the Project name - Resource group and all other resources will be named after this
variable "project_name" {
  description = "The name of the project, which will be used for all resources"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created.."
  type        = string
}

variable "storage_accounts" {
  description = "List of storage accounts to create"
  type = map(object({
    name                     = string
    account_tier             = string
    access_tier              = string
    account_replication_type = string
    container_names          = list(string)
    tags                     = map(string)
  }))
}
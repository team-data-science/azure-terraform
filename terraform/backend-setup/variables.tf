# Variables for the Project name - Resource group and all other resources will be named after this
variable "project_name" {
  description = "The name of the project, which will be used for all resources"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created.."
  type        = string
}
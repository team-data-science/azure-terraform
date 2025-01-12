output "resource_group_name" {
  description = "The name of the resource group used for Terraform state storage."
  value       = azurerm_resource_group.terraform.name
}

output "storage_account_name" {
  description = "The name of the storage account where the Terraform state is stored."
  value       = azurerm_storage_account.tfstate.name
}

output "storage_account_id" {
  description = "The ID of the storage account used for Terraform state."
  value       = azurerm_storage_account.tfstate.id
}

output "storage_container_name" {
  description = "The name of the storage container where the Terraform state files are stored."
  value       = azurerm_storage_container.tfstate.name
}

output "storage_account_primary_access_key" {
  description = "The primary access key for the storage account (used for secure access)."
  value       = azurerm_storage_account.tfstate.primary_access_key
  sensitive   = true
}

output "storage_account_blob_endpoint" {
  description = "The blob service endpoint for the storage account."
  value       = azurerm_storage_account.tfstate.primary_blob_endpoint
}
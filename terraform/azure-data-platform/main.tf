resource "azurerm_resource_group" "this" {
  name     = "${var.project_name}-central"
  location = var.location
}

module "storage_accounts" {
  for_each = var.storage_accounts
  source   = "../modules/azure-storage"

  location                 = var.location
  resource_group_name      = azurerm_resource_group.this.name
  storage_account_name     = "${var.project_name}${each.value.name}"
  account_tier             = each.value.account_tier
  access_tier              = each.value.access_tier
  account_replication_type = each.value.account_replication_type
  container_names          = each.value.container_names
  tags                     = each.value.tags
}

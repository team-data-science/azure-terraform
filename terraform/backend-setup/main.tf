resource "azurerm_resource_group" "terraform" {
  name     = "${var.project_name}-terraform"
  location = var.location
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "${var.project_name}tfstate"
  resource_group_name      = azurerm_resource_group.terraform.name
  location                 = azurerm_resource_group.terraform.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
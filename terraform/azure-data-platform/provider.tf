terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "ldeazureproject-terraform"
    storage_account_name = "ldeazureprojecttfstate"
    container_name       = "tfstate"
    key                  = "state.tfstate"
  }
}

provider "azurerm" {
  features {}
}
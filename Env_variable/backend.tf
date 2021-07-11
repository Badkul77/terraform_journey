terraform {
  backend "azurerm" {
     resource_group_name = "namanbadkul"
    storage_account_name = "storageaccountnaman"
    container_name       = "tfstate"
    key = "Env_variable.tfstate"
  }
}
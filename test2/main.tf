provider "azurerm" {
  features {}
}
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "namanbadkul" {
  name                = "kvult-01"
  location            = "Central India"
  resource_group_name = "namanbadkul"
  tenant_id           = "a45fe71a-f480-4e42-ad5e-aff33165aa35"
  sku_name            = "standard"
}
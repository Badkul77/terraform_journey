provider "azurerm" {
  skip_provider_registration = true
  features {}
}
resource "azurerm_resource_group" "fe-rg" {
  name     = var.fe-rg-name
  location = var.location-name
}
resource "azurerm_virtual_network" "fe-rg" {
  name                = var.fe-vnet-name
  resource_group_name = azurerm_resource_group.fe-rg.name
  location            = azurerm_resource_group.fe-rg.location
  address_space       = ["10.0.0.0/23"]
}
resource "azurerm_subnet" "fe-rg-1" {
  name                 = var.AzFirewall-sub-name
  resource_group_name  = azurerm_resource_group.fe-rg.name
  virtual_network_name = azurerm_virtual_network.fe-rg.name
  address_prefixes     = ["10.0.0.0/24"]
}
resource "azurerm_subnet" "fe-rg-2" {
  name                 = var.jb-sub-name
  resource_group_name  = azurerm_resource_group.fe-rg.name
  virtual_network_name = azurerm_virtual_network.fe-rg.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_public_ip" "fe-rg" {
  name                = var.pip-name
  resource_group_name = azurerm_resource_group.fe-rg.name
  location            = azurerm_resource_group.fe-rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_firewall" "fe-rg" {
  name                = var.fw-name
  location            = azurerm_resource_group.fe-rg.location
  resource_group_name = azurerm_resource_group.fe-rg.name

  ip_configuration {
    name                 = "fwip-config"
    subnet_id            = azurerm_subnet.fe-rg-1.id
    public_ip_address_id = azurerm_public_ip.fe-rg.id
  }
}

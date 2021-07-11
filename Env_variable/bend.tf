resource "azurerm_resource_group" "be-rg" {
  name     = var.be-rg-name
  location = var.location-name
}
resource "azurerm_virtual_network" "be-rg" {
  name                = var.web-vnet-name
  location            = azurerm_resource_group.be-rg.location
  resource_group_name = azurerm_resource_group.be-rg.name
  address_space       = ["10.0.2.0/23"]
}
resource "azurerm_subnet" "be-rg" {
  name                 = var.web-sub-name
  resource_group_name  = azurerm_resource_group.be-rg.name
  virtual_network_name = azurerm_virtual_network.be-rg.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_network_interface" "be-rg" {
  name                = "${var.web-vm-name}-nic"
  location            = azurerm_resource_group.be-rg.location
  resource_group_name = azurerm_resource_group.be-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.be-rg.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_security_group" "be-rg" {
  name                = "${var.web-vm-name}-nsg"
  location            = azurerm_resource_group.be-rg.location
  resource_group_name = azurerm_resource_group.be-rg.name
}
resource "azurerm_network_security_rule" "name" {
  name                        = "web"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "${azurerm_network_interface.be-rg.private_ip_address}/32"
  resource_group_name         = azurerm_resource_group.be-rg.name
  network_security_group_name = azurerm_network_security_group.be-rg.name
}
resource "azurerm_network_interface_security_group_association" "be-rg" {
  network_interface_id      = azurerm_network_interface.be-rg.id
  network_security_group_id = azurerm_network_security_group.be-rg.id
}
resource "azurerm_virtual_machine" "be-rg" {
  name                  = "${var.web-vm-name}-vm01"
  location              = azurerm_resource_group.be-rg.location
  resource_group_name   = azurerm_resource_group.be-rg.name
  network_interface_ids = [azurerm_network_interface.be-rg.id]
  vm_size               = "Standard_B2s"


  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.web-vm-name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.web-vm-name}-vm01"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_windows_config {
    enable_automatic_upgrades = true
    provision_vm_agent        = true
  }
}
resource "azurerm_virtual_machine_extension" "be-rg" {
  name                 = "iis extention"
  virtual_machine_id   = azurerm_virtual_machine.be-rg.id
  publisher            = "Microsoft.compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings             = <<SETTINGS
    {
        "commandToExecute": "powershell Install-WindowsFeature -name Web-Server -IncludeManagementTools;"
    }
       SETTINGS
}
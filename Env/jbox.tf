resource "azurerm_resource_group" "jbox-rg" {
  name     = "Jbox-rg"
  location = "centralindia"
}
resource "azurerm_network_interface" "jbox-rg" {
  name                = "jbox-nic"
  location            = azurerm_resource_group.jbox-rg.location
  resource_group_name = azurerm_resource_group.jbox-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.fe-rg-2.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_security_group" "jbox-rg" {
  name                = "jbox-nsg"
  location            = azurerm_resource_group.jbox-rg.location
  resource_group_name = azurerm_resource_group.jbox-rg.name
}
resource "azurerm_network_security_rule" "jbox-rg" {
  name                        = "rdp"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "${azurerm_network_interface.jbox-rg.private_ip_address}/32"
  resource_group_name         = azurerm_resource_group.jbox-rg.name
  network_security_group_name = azurerm_network_security_group.jbox-rg.name
}
resource "azurerm_network_interface_security_group_association" "jbox-rg" {
  network_interface_id      = azurerm_network_interface.jbox-rg.id
  network_security_group_id = azurerm_network_security_group.jbox-rg.id
}
resource "azurerm_virtual_machine" "jbox-rg" {
  name                  = "jbox-vm01"
  location              = azurerm_resource_group.jbox-rg.location
  resource_group_name   = azurerm_resource_group.jbox-rg.name
  network_interface_ids = [azurerm_network_interface.jbox-rg.id]
  vm_size               = "Standard_B2s"


  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "jbox-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "jbox-vm01"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_windows_config {
    enable_automatic_upgrades = true
    provision_vm_agent        = true
  }
}

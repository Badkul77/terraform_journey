variable location-name {
  type    = string
  default = "centralindia"
}
variable "fe-rg-name" {
  type = string
  default = "Fe-rg"
}
variable "fe-vnet-name" {
  type = string
  default = "Fe-vnet"
}
variable AzFirewall-sub-name {
  type    = string
  default = "AzureFirewallSubnet"
}
variable pip-name {
  type    = string
  default = "Pub-ip01"
}
variable fw-name {
  type    = string
  default = "FW-01"
}
variable be-rg-name {
  type    = string
  default = "Be-rg"
}
variable web-vnet-name {
  type    = string
  default = "Web-vnet"
}
variable web-sub-name {
  type    = string
  default = "Web-subnet"
}
variable web-vm-name {
  type    = string
  default = "Web"
}
variable jb-rg-name {
  type    = string
  default = "Jbox-rg"
}
variable jb-sub-name {
  type    = string
  default = "Jbox-subnet"
}
variable jb-vm-name {
  type    = string
  default = "Jbox"
}
variable admin_username {
  type    = string
  default = "testadmin"
}
variable admin_password {
  type    = string
  default = "Password1234!"
}
output "resource_group" {
  value = azurerm_resource_group.main.name
}

output "frontdoor_name" {
  value = azurerm_linux_virtual_machine.frontdoor.name
}
output "frontdoor_ip" {
  value = azurerm_public_ip.pip.ip_address
}
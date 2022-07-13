
resource "azurerm_linux_virtual_machine" "frontdoor" {
  name                            = "${var.environment_name}-dso-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = var.frontdoor_vm_size
  admin_username                  = var.frontdoor_admin_user
  admin_password                  = var.frontdoor_admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.id,
    azurerm_network_interface.internal.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "StandardSSD_ZRS"
    caching              = "ReadWrite"
  }
}

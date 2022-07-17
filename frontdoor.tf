
data "template_file" "linux-vm-cloud-init" {
  template = file("frontdoor.sh")
}

resource "azurerm_linux_virtual_machine" "frontdoor" {
  name                            = "${var.environment_name}-dso-frontdoor-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = var.frontdoor_vm_size
  admin_username                  = var.frontdoor_admin_user
  admin_password                  = var.frontdoor_admin_password
  disable_password_authentication = false

  custom_data    = base64encode(data.template_file.linux-vm-cloud-init.rendered)

  network_interface_ids = [
    azurerm_network_interface.external.id,
    azurerm_network_interface.internal.id,
  ]

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-pro-advanced-sla"
    sku       = "18_04-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "StandardSSD_ZRS"
    caching              = "ReadWrite"
  }
}

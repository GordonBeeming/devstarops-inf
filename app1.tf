
resource "azurerm_network_interface" "app1-internal" {
  name                      = "${var.environment_name}-dso-int-app1-nic"
  resource_group_name       = data.azurerm_resource_group.main.name
  location                  = data.azurerm_resource_group.main.location

  ip_configuration {
    name                          = "app1-internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

data "template_file" "app1-cloud-init" {
  template = file("app1.sh")
  vars = {
    resource_group_name = data.azurerm_resource_group.main.name
    storage_account_name = azurerm_storage_account.app_data.name
    github_username = "devstarops"
    github_token = var.github_token
  }
}

resource "azurerm_linux_virtual_machine" "app1" {
  name                            = "${var.environment_name}-dso-app1-vm"
  resource_group_name             = data.azurerm_resource_group.main.name
  location                        = data.azurerm_resource_group.main.location
  size                            = var.app1_vm_size
  admin_username                  = var.app1_admin_user
  admin_password                  = var.app1_admin_password
  disable_password_authentication = false

  custom_data    = base64encode(data.template_file.app1-cloud-init.rendered)

  network_interface_ids = [
    azurerm_network_interface.app1-internal.id,
  ]

  identity {
    type = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.app1.id ]
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-groovy"
    sku       = "20_10-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "StandardSSD_ZRS"
    caching              = "ReadWrite"
  }
}

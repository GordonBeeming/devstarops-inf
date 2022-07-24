
resource "azurerm_network_interface" "frontdoor-external" {
  name                = "${var.environment_name}-dso-ext-frontdoor-nic"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  ip_configuration {
    name                          = "frontdoor-external"
    subnet_id                     = azurerm_subnet.external.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_interface" "frontdoor-internal" {
  name                      = "${var.environment_name}-dso-int-frontdoor-nic"
  resource_group_name       = data.azurerm_resource_group.main.name
  location                  = data.azurerm_resource_group.main.location

  ip_configuration {
    name                          = "frontdoor-internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

data "template_file" "frontdoor-cloud-init" {
  template = file("frontdoor.sh")
  vars = {
    resource_group_name = data.azurerm_resource_group.main.name
    storage_account_name = azurerm_storage_account.app_data.name
    app1_ipaddress = azurerm_network_interface.app1-internal.ip_configuration[0].private_ip_address    
  }
}

resource "azurerm_linux_virtual_machine" "frontdoor" {
  name                            = "${var.environment_name}-dso-frontdoor-vm"
  resource_group_name             = data.azurerm_resource_group.main.name
  location                        = data.azurerm_resource_group.main.location
  size                            = var.frontdoor_vm_size
  admin_username                  = var.frontdoor_admin_user
  admin_password                  = var.frontdoor_admin_password
  disable_password_authentication = false

  custom_data    = base64encode(data.template_file.frontdoor-cloud-init.rendered)

  network_interface_ids = [
    azurerm_network_interface.frontdoor-external.id,
    azurerm_network_interface.frontdoor-internal.id,
  ]

  identity {
    type = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.frontdoor.id ]
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

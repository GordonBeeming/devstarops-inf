
resource "azurerm_virtual_network" "main" {
  name                = "${var.environment_name}-dso-network"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_subnet" "external" {
  name                 = "external"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  resource_group_name  = "${data.azurerm_resource_group.main.name}"
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  resource_group_name  = "${data.azurerm_resource_group.main.name}"
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.environment_name}-dso-pip"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  allocation_method   = "Static"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_network_security_group" "edge-nsg" {
  name                = "${var.environment_name}-dso-nsg"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  # enable_ip_forwarding = true

  security_rule {
    access                     = "Deny"
    direction                  = "Inbound"
    name                       = "http"
    priority                   = 150
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "80"
    destination_address_prefix = azurerm_network_interface.frontdoor-external.private_ip_address
  }
  
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "https"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "443"
    destination_address_prefix = azurerm_network_interface.frontdoor-external.private_ip_address
  }
  
  security_rule {
    access                     = var.sshAccess
    direction                  = "Inbound"
    name                       = "ssh-frontdoor"
    priority                   = 160
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "22"
    destination_address_prefix = azurerm_network_interface.frontdoor-external.private_ip_address
  }
  
}

resource "azurerm_network_interface_security_group_association" "frontdoor-external" {
  network_interface_id      = azurerm_network_interface.frontdoor-external.id
  network_security_group_id = azurerm_network_security_group.edge-nsg.id
}

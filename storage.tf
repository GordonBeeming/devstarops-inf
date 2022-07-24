resource "azurerm_storage_account" "app_data" {
  name                     = "dso${var.environment_name}storage"
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = data.azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_account_network_rules" "internal" {
  storage_account_id = azurerm_storage_account.app_data.id

  default_action             = "Allow"
  ip_rules                   = []
  virtual_network_subnet_ids = [azurerm_subnet.internal.id]
  bypass                     = ["None"]
}

resource "azurerm_storage_account" "app_data" {
  name                     = "dso${var.environment_name}storage"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "app_data" {
  name                  = "appdata"
  storage_account_name  = azurerm_storage_account.app_data.name
  container_access_type = "private"
}

resource "azurerm_storage_account_network_rules" "internal" {
  storage_account_id = azurerm_storage_account.app_data.id

  default_action             = "Allow"
  ip_rules                   = []
  virtual_network_subnet_ids = [azurerm_subnet.internal.id]
  bypass                     = ["None"]
}

resource "azurerm_role_assignment" "frontdoor_appdata_access" {
  scope                = azurerm_storage_account.app_data.id
  role_definition_name = "Reader and Data Access"
  principal_id         = azurerm_user_assigned_identity.frontdoor.principal_id
}
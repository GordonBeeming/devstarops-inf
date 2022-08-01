resource "azurerm_role_assignment" "app1_appdata_access" {
  scope                = azurerm_storage_account.app_data.id
  role_definition_name = "Reader and Data Access"
  principal_id         = azurerm_user_assigned_identity.app1.principal_id
}

resource "azurerm_storage_container" "profile" {
  name                  = "profile"
  storage_account_name  = azurerm_storage_account.app_data.name
  container_access_type = "private"
}
resource "azurerm_storage_container" "blog" {
  name                  = "blog"
  storage_account_name  = azurerm_storage_account.app_data.name
  container_access_type = "private"
}

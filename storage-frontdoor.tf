resource "azurerm_storage_container" "frontdoor" {
  name                  = "frontdoor"
  storage_account_name  = azurerm_storage_account.app_data.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "frontdoor_appdata_access" {
  scope                = azurerm_storage_account.app_data.id
  role_definition_name = "Reader and Data Access"
  principal_id         = azurerm_user_assigned_identity.frontdoor.principal_id
}

resource "azurerm_storage_blob" "domain_pem" {
  name                   = "domain.pem"
  storage_account_name   = azurerm_storage_account.app_data.name
  storage_container_name = azurerm_storage_container.frontdoor.name
  type                   = "Block"
  source                 = "resources/domain.pem"
}

resource "azurerm_storage_blob" "domain_key" {
  name                   = "domain.key"
  storage_account_name   = azurerm_storage_account.app_data.name
  storage_container_name = azurerm_storage_container.frontdoor.name
  type                   = "Block"
  source                 = "resources/domain.key"
}

resource "azurerm_storage_account" "app_data" {
  name                            = "dso${var.environment_name}storage"
  resource_group_name             = data.azurerm_resource_group.main.name
  location                        = data.azurerm_resource_group.main.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false

  lifecycle {
    prevent_destroy = true
  }
}

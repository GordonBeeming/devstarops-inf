resource "azurerm_user_assigned_identity" "frontdoor" {
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  name = "${var.environment_name}-frontdoor-user"
}

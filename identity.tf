resource "azurerm_user_assigned_identity" "frontdoor" {
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  name = "${var.environment_name}-frontdoor-user"
}
resource "azurerm_user_assigned_identity" "app1" {
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  name = "${var.environment_name}-app1-user"
}

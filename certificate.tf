resource "azurerm_key_vault_certificate" "main" {
  name         = "main-cert"
  key_vault_id = azurerm_key_vault.main.id

  certificate {
    contents = cloudflare_origin_ca_certificate.domain.certificate
    password = ""
  }
  
}
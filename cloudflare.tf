# Create a CSR and generate a CA certificate
resource "tls_private_key" "domain" {
  algorithm = "RSA"
}

resource "tls_cert_request" "domain" {
  private_key_pem = tls_private_key.domain.private_key_pem

  subject {
    common_name  = var.edge_hostname
    organization = "Gordon Beeming [Dev⭐Ops]"
  }
}

resource "cloudflare_origin_ca_certificate" "domain" {
  csr                = tls_cert_request.domain.cert_request_pem
  hostnames          = [ var.edge_hostname ]
  request_type       = "origin-rsa"
  requested_validity = 5475
}

resource "cloudflare_record" "main" {
  zone_id = var.cloudflare_zone_id
  name    = var.edge_dns_record
  value   = azurerm_public_ip.pip.ip_address
  type    = "A"
  ttl     = 1
  proxied = true
  allow_overwrite = false
}

resource "local_sensitive_file" "domain_pem" {
    content  = cloudflare_origin_ca_certificate.domain.certificate
    filename = "resources/domain.pem"
}

resource "local_sensitive_file" "domain_key" {
    content  = tls_private_key.domain.private_key_pem
    filename = "resources/domain.key"
}

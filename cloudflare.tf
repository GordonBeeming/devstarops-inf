# Create a CSR and generate a CA certificate
resource "tls_private_key" "domain" {
  algorithm = "RSA"
}

resource "tls_cert_request" "domain" {
  private_key_pem = tls_private_key.domain.private_key_pem

  subject {
    common_name  = var.edge_hostname
    organization = "Gordon Beeming"
  }
}

resource "cloudflare_origin_ca_certificate" "domain" {
  csr                = tls_cert_request.domain.cert_request_pem
  hostnames          = [ var.edge_hostname ]
  request_type       = "origin-rsa"
  requested_validity = 5475
}

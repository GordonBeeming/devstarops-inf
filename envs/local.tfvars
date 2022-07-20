deploy_region = "westeurope"
resource_group_name = "devstarops-local-rg"
environment_name = "local"

sshAccess = "Deny" # Allow or Deny

frontdoor_vm_size = "Standard_DS2_v2"
frontdoor_admin_user = "adminuser"
# frontdoor_admin_password = local env variable

# cloudflare_api_token = local env variable
# cloudflare_service_key = local env variable
# cloudflare_zone_id = local env variable
edge_hostname = "local.devstarops.com"
edge_dns_record = "local"

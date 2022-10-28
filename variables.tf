variable "deploy_region" {
  type = string
  default = "westeurope"
}

variable "resource_group_name" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "sshAccess" {
  type = string
  default = "Deny"
}

variable "frontdoor_vm_size" {
  type = string
}
variable "frontdoor_admin_user" {
  type = string
  sensitive = true
}
variable "frontdoor_admin_password" {
  type = string
  sensitive = true
}

variable "app1_vm_size" {
  type = string
}
variable "app1_admin_user" {
  type = string
  sensitive = true
}
variable "app1_admin_password" {
  type = string
  sensitive = true
}

variable "cloudflare_api_token" {
  type = string
  sensitive = true
}

variable "cloudflare_origin_ca_key" {
  type = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  type = string
}

variable "edge_dns_record" {
  type = string
}

variable "edge_hostname" {
  type = string
}



variable "github_token" {
  type = string
  sensitive = true
}

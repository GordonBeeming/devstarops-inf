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

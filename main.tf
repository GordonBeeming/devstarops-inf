terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "= 3.23.0"
    }
  }

  required_version = "= 1.3.2"

  backend "azurerm" {}
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

provider "cloudflare" {
  api_client_logging = false
  email = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}


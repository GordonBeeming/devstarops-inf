terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }

  required_version = "= 1.2.4"

  backend "azurerm" {}
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}


# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.deploy_region
}

data "azurerm_client_config" "current" {}
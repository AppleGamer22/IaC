terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.18.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret#creating-a-service-principal-using-the-azure-cli
# https://docs.env0.com/docs/connect-your-cloud-account#azure
# TODO: DON'T FORGET THIS az CLI FLAG
# $ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/20000000-0000-0000-0000-000000000000"
provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  resource_provider_registrations = "none"
  # subscription_id = var.azure_subscription_id
}

provider "tailscale" {
  api_key = var.tailscale_api_key
  tailnet = var.tailnet_name
}

module "ts" {
  source            = "../ts"
  tailscale_api_key = var.tailscale_api_key
}

# resource "random_pet" "rg_name" {
#   prefix = var.resource_group_name_prefix
# }

resource "azurerm_resource_group" "az_resource_group" {
  location = var.az_region
  name     = var.az_region
}


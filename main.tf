terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=v4.14.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=v3.6.3"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id = ""
  features {
    virtual_machine {
      delete_os_disk_on_deletion = false
    }
  }
}
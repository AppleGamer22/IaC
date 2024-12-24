terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "v4.14.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "v3.6.3"
    }
  }

  # https://docs.env0.com/docs/login
  cloud {
    hostname     = "backend.api.env0.com"
    organization = "${var.env0_org_id}.${env0_project_id}"
    workspaces {
      name = "applegamer22"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = false
    }
  }
}
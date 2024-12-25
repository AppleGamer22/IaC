terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }

  # https://docs.env0.com/docs/login
  cloud {
    hostname     = "backend.api.env0.com"
    organization = "b3499f32-a43e-4c06-8621-ac29962e7e98.9e6bd561-3f2f-467d-b30a-1469c7a8c49d"
    workspaces {
      name = "applegamer22"
    }
  }
}

provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = false
    }
  }
}

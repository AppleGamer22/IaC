terraform {
  # https://docs.env0.com/docs/login
  cloud {
    hostname     = "backend.api.env0.com"
    organization = "b3499f32-a43e-4c06-8621-ac29962e7e98.9e6bd561-3f2f-467d-b30a-1469c7a8c49d"
    workspaces {
      name = "applegamer22"
    }
  }
}


module "az" {
  source = "./modules/az"
  azure_subscription_id = var.azure_subscription_id
  tailscale_api_key = var.tailscale_api_key
}


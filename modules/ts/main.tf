terraform {
  required_providers {
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.18.0"
    }
  }
}


provider "tailscale" {
  api_key = var.tailscale_api_key
  tailnet = "applegamer22.github"
}

resource "tailscale_tailnet_key" "tailscale_key" {
  reusable      = true
  ephemeral     = false
  preauthorized = true
  expiry        = 7776000
  description   = "IaC Tailscale key (90 days)"
}

output "tailnet_key" {
  value       = tailscale_tailnet_key.tailscale_key.key
  sensitive   = true
  depends_on  = [tailscale_tailnet_key.tailscale_key]
  description = "IaC Tailnet Key"
}

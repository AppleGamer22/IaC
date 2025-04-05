variable "tailnet_name" {
  type = string
  default = "applegamer22.github"
}

variable "tailscale_api_key" {
  type        = string
  sensitive   = true
  description = "Tailscale API Key"
}


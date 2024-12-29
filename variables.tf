# variable "env0_org_id" {
#   type      = string
#   sensitive = true
# }

# variable "env0_project_id" {
#   type      = string
#   sensitive = true
# }

variable "tailscale_api_key" {
  type        = string
  sensitive   = true
  description = "Tailscale API Key"
}

variable "tailscale_auth_key" {
  type        = string
  sensitive   = true
  description = "Tailscale Authentication Key"
}

# variable "env0_org_id" {
#   type      = string
#   sensitive = true
# }

# variable "env0_project_id" {
#   type      = string
#   sensitive = true
# }

variable "tailnet_name" {
  type    = string
  default = "applegamer22.github"
}

variable "tailscale_api_key" {
  type        = string
  sensitive   = true
  description = "Tailscale API Key"
}

variable "az_region" {
  type        = string
  description = "Location of the resource group."
}

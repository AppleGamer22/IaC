# variable "env0_org_id" {
#   type      = string
#   sensitive = true
# }

# variable "env0_project_id" {
#   type      = string
#   sensitive = true
# }

variable "tailnet_name" {
  type = string
  default = "applegamer22.github"
}

variable "azure_subscription_id" {
  type = string
  sensitive = true
  description = "Azure Subscription ID"
}

variable "tailscale_api_key" {
  type        = string
  sensitive   = true
  description = "Tailscale API Key"
}
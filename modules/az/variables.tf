# variable "azure_subscription_id" {
#   type = string
#   sensitive = true
#   description = "Azure Subscription ID"
# }

variable "az_region" {
  type        = string
  default     = "israelcentral"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = ""
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "az_vm_size" {
  type    = string
  default = "B1s"
}

variable "username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "applegamer22"
}

variable "tailnet_name" {
  type    = string
  default = "applegamer22.github"
}

variable "tailscale_api_key" {
  type        = string
  sensitive   = true
  description = "Tailscale API Key"
}

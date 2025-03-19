variable "azure_subscription_id" {
  type = string
  sensitive = true
  description = "Azure Subscription ID"
}

variable "resource_group_location" {
  type        = string
  # default     = "australiaeast"
  # default     = "australiasoutheast"
  # default     = "eastus"
  default     = "israelcentral"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "applegamer22"
}

variable "tailscale_api_key" {
  type        = string
  sensitive   = true
  description = "Tailscale API Key"
}
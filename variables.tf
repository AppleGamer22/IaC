variable "tenancy_ocid" {
  type      = string
  sensitive = true
}

variable "user_ocid" {
  type      = string
  sensitive = true
}

variable "fingerprint" {
  type      = string
  sensitive = true
}

variable "region_id" {
  type      = string
  sensitive = false
  default   = "ap-melbourne-1"
}

variable "private_rsa_key_path" {
  type      = string
  sensitive = true
  default   = "$HOME/.oci/oci.pem"
}

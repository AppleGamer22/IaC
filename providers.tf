provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  region           = var.region_id
  private_key_path = var.private_rsa_key_path
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

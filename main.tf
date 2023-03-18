terraform {
  required_version = ">= 1.3.6"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.104.0"
    }
  }
  # cloud {
  #   organization = "applegamer22"
  #   workspaces {
  #     name = "oci"
  #   }
  # }
}

resource "oci_identity_compartment" "identity_compartment" {
  compartment_id = var.tenancy_ocid
  name           = "oci"
}

resource "oci_core_vcn" "vcn" {
  compartment_id = var.tenancy_ocid
  display_name   = "oci_vcn"
}

resource "oci_core_instance" "vm" {
  # Required
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.tenancy_ocid
  shape               = "VM.Standard.A1.Flex"
  source_details {
    source_id   = "Canonical-Ubuntu-22.04-Minimal-aarch64-2022.11.05-0"
    source_type = "image"
  }

  # Optional
  display_name = "oci_vm"
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_vcn.vcn.id
  }
  metadata = {
    ssh_authorized_keys = file("$HOME/.ssh/id_rsa.pub")
  }
}

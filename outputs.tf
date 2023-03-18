output "all-availability-domains-in-your-tenancy" {
  value = data.oci_identity_availability_domains.ads.availability_domains
}

output "availability-domain" {
  value = data.oci_identity_availability_domains.ads.availability_domains[0].name
}

output "compartment-ocid" {
  value = oci_identity_compartment.tf-compartment.id
}

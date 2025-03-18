resource "tls_private_key" "dummy_key" {
    algorithm = "RSA"
    rsa_bits = 4096
}
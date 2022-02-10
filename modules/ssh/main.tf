# resource "tls_private_key" "ssh" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "ssh" {
#   key_name = "${var.prefix}-${var.client}-kp"
#   public_key = tls_private_key.ssh.public_key_openssh
  
#   tags = {
#     "Name" = "${var.prefix}-${var.client}-kp",
#     "cliente" = var.client,
#     "ambiente" = "dev"
#   }
# }

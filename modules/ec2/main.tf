resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name = "${var.prefix}-${var.client}-kp"
  public_key = tls_private_key.ssh.public_key_openssh
  
  tags = {
    "Name" = "${var.prefix}-${var.client}-kp",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

resource "aws_security_group" "api-private-sg" {
  name = "${var.prefix}-api-private-sg"
  description = "Security Group to allow access to the internal EC2 instance in the private API subnet"
  vpc_id = var.vpc_main_id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  tags = {
    "Name" = "${var.prefix}-api-private-sg",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

# resource "aws_instance" "api-private-ec2" {
#   instance_type = "t2.micro"
#   ami = "ami-0cd88166878525f29" # (Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type)
#   # subnet_id = aws_subnet.api-subnets[0].id
#   subnet_id = var.api_subnet_ids[0].id
#   security_groups = [aws_security_group.api-private-sg.id]
#   key_name = aws_key_pair.ssh.key_name
#   disable_api_termination = false
#   ebs_optimized = false
#   root_block_device {
#     volume_size = "10"
#   }

#   tags = {
#     "Name" = "${var.prefix}-api-private-ec2",
#     "cliente" = var.client,
#     "ambiente" = "dev"
#   }
# }

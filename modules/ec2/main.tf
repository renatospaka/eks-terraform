########################################
# Key pair to aloow SSH to the bastion
# server 
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name = "${var.prefix}-ec2-kp"
  public_key = tls_private_key.ssh.public_key_openssh
  
  tags = {
    "Name" = "${var.prefix}-ec2-kp",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

locals {
  pem = tls_private_key.ssh.private_key_pem
}

resource "local_file" "ssh" {
  filename = "${var.prefix}-ec2-kp.pem"
  content = local.pem
}

resource "null_resource" "ssh" {
  depends_on = [
    aws_instance.web-public-ec2,
    local_file.ssh
  ]
  provisioner "local-exec" {
    command = "chmod 400 ${var.prefix}-ec2-kp.pem"
  }
}

########################################
# Security group to allow access to the
# bastion server. All SSH setup must be
# executed manually
resource "aws_security_group" "developers-sg" {
  name = "${var.prefix}-developers-sg"
  description = "Security Group to allow inbound access for the developer team"
  vpc_id = var.vpc_main_id
  ingress {
    cidr_blocks = ["277.277.277.277/104"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
    description = "Allows inbound ssh connections from the Internet to Fields"
  }
  ingress {
    cidr_blocks = ["277.277.277.277/104"]
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    description = "Allows inbound Postgres connections from the Internet to Fields"
  }
  ingress {
    cidr_blocks = ["277.277.277.277/104"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
    description = "Allows inbound ssh connections from the Internet to Tevao"
  }
  ingress {
    cidr_blocks = ["277.277.277.277/104"]
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    description = "Allows inbound Postgres connections from the Internet to Tevao"
  }
  ingress {
    cidr_blocks = ["277.277.277.277/104"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
    description = "Allows inbound ssh connections from the Internet to Spaka"
  }
  ingress {
    cidr_blocks = ["277.277.277.277/104"]
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    description = "Allows inbound Postgres connections from the Internet to Spaka"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
    description = "Allows outbound communication to anywhere"
  }

  tags = {
    "Name" = "${var.prefix}-developers-sg",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

resource "aws_security_group" "web-public-sg" {
  name = "${var.prefix}-web-public-sg"
  description = "Security Group to allow inbound access to the internal EC2 instance in the private API subnet"
  vpc_id = var.vpc_main_id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
    description = "Allows inbound ssh connections from the Internet"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 2376
    to_port = 2376
    protocol = "tcp"
    description = "Allows inbound connections from Rancher"
  }
  ingress {
    security_groups = [aws_security_group.developers-sg.id]
    from_port = 22
    to_port = 22
    protocol = "tcp"
    description = "Allows inbound ssh connections from the Internet for the developer team"
  }
  ingress {
    security_groups = [aws_security_group.developers-sg.id]
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    description = "Allows inbound Postgres connections from the Internet for the developer team"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
    description = "Allows outbound communication to anywhere"
  }

  tags = {
    "Name" = "${var.prefix}-web-public-sg",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

resource "aws_security_group" "ec2-private-sg" {
  name = "${var.prefix}-ec2-private-sg"
  description = "Security Group to allow access to the internal EC2 instance in the private API subnet"
  vpc_id = var.vpc_main_id
  # ingress {
  #   cidr_blocks = ["0.0.0.0/0"]
  #   from_port = 22
  #   to_port = 22
  #   protocol = "tcp"
  #   description = "Allows inbound ssh connections from my personal IP"
  # }
  ingress {
    security_groups = [aws_security_group.web-public-sg.id]
    from_port = 22
    to_port = 22
    protocol = "tcp"
    description = "Allows inbound ssh connections from the Internet for the developer team"
  }
  ingress {
    security_groups = [aws_security_group.web-public-sg.id]
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    description = "Allows inbound Postgres connections from the Internet for the developer team"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
    description = "Allows outbound communication to anywhere"
  }

  tags = {
    "Name" = "${var.prefix}-ec2-private-sg",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

########################################
# EC2 public instance 
# bastion server
resource "aws_instance" "web-public-ec2" {
  instance_type = "t3.micro"
  ami = "ami-0cd88166878525f29" # (Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type)
  subnet_id = var.web_subnet_id_bastion
  security_groups = [aws_security_group.web-public-sg.id]
  key_name = aws_key_pair.ssh.key_name
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "10"
  }

  tags = {
    "Name" = "${var.prefix}-web-public-ec2",
    "cliente" = var.client,
    "ambiente" = "dev",
    "type" = "bastion"
  }
}


########################################
# EC2 private instances 
# API & DB subnets
resource "aws_instance" "api-private-ec2" {
  instance_type = "t3.micro"
  ami = "ami-0cd88166878525f29" # (Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type)
  subnet_id = var.api_subnet_id_bastion
  security_groups = [aws_security_group.ec2-private-sg.id]
  key_name = aws_key_pair.ssh.key_name
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "10"
  }

  tags = {
    "Name" = "${var.prefix}-api-private-ec2",
    "cliente" = var.client,
    "ambiente" = "dev",
    "type" = "bastion"
  }
}

resource "aws_instance" "db-private-ec2" {
  instance_type = "t3.micro"
  ami = "ami-0cd88166878525f29" # (Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type)
  subnet_id = var.db_subnet_id_bastion
  security_groups = [aws_security_group.ec2-private-sg.id]
  key_name = aws_key_pair.ssh.key_name
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "10"
  }

  tags = {
    "Name" = "${var.prefix}-db-private-ec2",
    "cliente" = var.client,
    "ambiente" = "dev",
    "type" = "bastion"
  }
}

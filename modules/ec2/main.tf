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


########################################
# instância pública EC2 - WEB - bastion
resource "aws_security_group" "web-public-sg" {
  name = "${var.prefix}-web-public-sg"
  description = "Security Group to allow access to the internal EC2 instance in the private API subnet"
  vpc_id = var.vpc_main_id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
    description = "Allows inbound ssh from my personal IP"
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
    "Name" = "${var.prefix}-web-private-ec2",
    "cliente" = var.client,
    "ambiente" = "dev",
    "type" = "bastion"
  }
}


########################################
# instância privada EC2 - API
resource "aws_security_group" "ec2-private-sg" {
  name = "${var.prefix}-ec2-private-sg"
  description = "Security Group to allow access to the internal EC2 instance in the private API subnet"
  vpc_id = var.vpc_main_id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
    description = "Allows inbound ssh from my personal IP"
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

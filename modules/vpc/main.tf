resource "aws_vpc" "main-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    "Name" = "${var.prefix}-main-vpc",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

data "aws_availability_zones" "available" {}



########################################
# starting public subnet - WEB
resource "aws_subnet" "web-subnets" {
  count = var.web_subnets_size
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.prefix}-subnet-web-${count.index+1}",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

resource "aws_eip" "main-natgw-eip" {
  vpc = true
  
  tags = {
    "Name" = "${var.prefix}-main-natgw-eip",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

resource "aws_nat_gateway" "main-natgw" {
  allocation_id = aws_eip.main-natgw-eip.id
  subnet_id = aws_subnet.web-subnets[0].id
  depends_on = [
      aws_internet_gateway.main-igw, 
      aws_eip.main-natgw-eip
    ]

  tags = {
    "Name" = "${var.prefix}-main-natgw",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    "Name" = "${var.prefix}-main-igw",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

resource "aws_route_table" "web-rtb" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    "Name" = "${var.prefix}-main-rtb",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

resource "aws_route_table_association" "web-rtb-association" {
  count = var.web_subnets_size
  route_table_id = aws_route_table.web-rtb.id
  subnet_id = aws_subnet.web-subnets.*.id[count.index]
}


########################################
# starting private subnet - API
resource "aws_subnet" "api-subnets" {
  count = var.api_subnets_size
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = "10.0.${count.index+10}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${var.prefix}-subnet-api-${count.index+1}",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

resource "aws_route_table" "api-rtb" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main-natgw.id
  }

  tags = {
    "Name" = "${var.prefix}-api-rtb",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

resource "aws_route_table_association" "api-rtb-association" {
  count = var.api_subnets_size
  route_table_id = aws_route_table.api-rtb.id
  subnet_id = aws_subnet.api-subnets.*.id[count.index]
}


########################################
# starting private subnet - DB
resource "aws_subnet" "db-subnets" {
  count = var.db_subnets_size
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = "10.0.${count.index+20}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${var.prefix}-subnet-db-${count.index+1}",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

resource "aws_route_table" "db-rtb" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main-natgw.id
  }

  tags = {
    "Name" = "${var.prefix}-db-rtb",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

resource "aws_route_table_association" "db-rtb-association" {
  count = var.db_subnets_size
  route_table_id = aws_route_table.db-rtb.id
  subnet_id = aws_subnet.db-subnets.*.id[count.index]
}



########################################
# new Postgress private instance
# 
# data "aws_subnets" "db-subnet-ids" {  # -> why doesn't work here?
#   filter {
#     name   = "vpc-id"
#     values = [aws_vpc.main-vpc.id]
#   }
# }

resource "aws_db_subnet_group" "db-subnet-grp" {
  name = "${var.prefix}-db-subnet-grp"
  subnet_ids = [aws_subnet.db-subnets[0].id, aws_subnet.db-subnets[1].id]
  # subnet_ids = [data.aws_subnets.db-subnet-ids.ids] # -> why doesn't work here?
  description = "subnet group to allow Multi AZ on this instance"

  tags = {
    "Name" = "${var.prefix}-db-subnet-grp",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}


resource "aws_db_instance" "db" {
  identifier = "${var.prefix}-db-instance"
  allocated_storage = 5
  max_allocated_storage = 10
  deletion_protection = false
  skip_final_snapshot = true
  publicly_accessible = false
  instance_class = "db.t3.micro"
  # parameter_group_name = "default.postgres-14"
  engine = "postgres"
  engine_version = "14.1"
  username = "d3bid"
  password = "dEUaC]xL&=8e?;nv2,"
  # name = "bid-mvp" - there is no way to provide instance name differently from database name
  db_name = "bid"
  port = "5432"
  vpc_security_group_ids = [var.sg-developers]
  db_subnet_group_name = aws_db_subnet_group.db-subnet-grp.name

  tags = {
    "Name" = "${var.prefix}-db",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
} 

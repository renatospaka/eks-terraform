resource "aws_vpc" "main-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "${var.prefix}-main-vpc",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

data "aws_availability_zones" "available" {}
# output "az" {
#   value = "${data.aws_availability_zones.available.names}"
# }

resource "aws_subnet" "web-subnets" {
  count = 2
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = "10.0.${count.index+3}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.prefix}-subnet-web-${count.index+1}",
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
  count = 2
  route_table_id = aws_route_table.web-rtb.id
  subnet_id = aws_subnet.web-subnets.*.id[count.index]
}

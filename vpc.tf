resource "aws_vpc" "fullcycle-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "${var.prefix}-vpc",
    "cliente" = "bid",
    "ambiente" = "dev"
  }
}

data "aws_availability_zones" "available" {}
# output "az" {
#   value = "${data.aws_availability_zones.available.names}"
# }

resource "aws_subnet" "subnets" {
  count = 2
  vpc_id = aws_vpc.fullcycle-vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.prefix}-subnet-${count.index+1}",
    "cliente" = "bid",
    "ambiente" = "dev"
  }
}

resource "aws_internet_gateway" "fullcycle-igw" {
  vpc_id = aws_vpc.fullcycle-vpc.id
  tags = {
    "Name" = "${var.prefix}-igw",
    "cliente" = "bid",
    "ambiente" = "dev"
  }
}

resource "aws_route_table" "fullcycle-rtb" {
  vpc_id = aws_vpc.fullcycle-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fullcycle-igw.id
  }
  tags = {
    "Name" = "${var.prefix}-rtb",
    "cliente" = "bid",
    "ambiente" = "dev"
  }
}

resource "aws_route_table_association" "fullcycle-rtb-association" {
  count = 2
  route_table_id = aws_route_table.fullcycle-rtb.id
  subnet_id = aws_subnet.subnets.*.id[count.index]
}

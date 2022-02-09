output "vpc_main_id" {
  value = aws_vpc.main-vpc.id
}

output "web_subnet_ids" {
  #resource-type.object.property =\/
  value = aws_subnet.web-subnets[*].id
}

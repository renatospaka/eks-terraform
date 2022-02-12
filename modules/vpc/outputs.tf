output "vpc_main_id" {
  value = aws_vpc.main-vpc.id
}

output "web_subnet_ids" {
  value = aws_subnet.web-subnets[*].id
}

output "web_subnet_id_bastion" {
  value = aws_subnet.web-subnets[2].id
}

output "api_subnet_id_bastion" {
  value = aws_subnet.api-subnets[0].id
}

output "db_subnet_id_bastion" {
  value = aws_subnet.db-subnets[1].id
}

output "vpc_main_id" {
  value = aws_vpc.main-vpc.id
}

output "web_subnet_ids" {
  #resource-type.object.property =\/
  value = aws_subnet.web-subnets[*].id
}

# output "api_subnet_ids" {
#   #resource-type.object.property =\/
#   value = aws_subnet.api-subnets[*].id
# }

# output "db_subnet_ids" {
#   #resource-type.object.property =\/
#   value = aws_subnet.db-subnets[*].id
# }

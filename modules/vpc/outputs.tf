output "vpc_main_id" {
  value = aws_vpc.main-vpc.id
}

output "web_subnet_ids" {
  value = aws_subnet.web-subnets[*].id
}

output "api_subnet_ids" {
  value = aws_subnet.api-subnets[*].id
}

# output "db_subnet_ids" {
#   # for_each = toset(aws_subnet.db-subnets)
#   # value = aws_subnet.db-subnets[*].id
#   # value = aws_subnet.db-subnets[*].id
#   value = aws_subnet.db-subnets.*.id
# }

# # output "db_subnet_id0" {
# #   value = aws_subnet.db-subnets[0]
# # }

# # output "db_subnet_id1" {
# #   value = aws_subnet.db-subnets[1]
# # }

output "web_subnet_id_bastion" {
  value = aws_subnet.web-subnets[2].id
}

output "api_subnet_id_bastion" {
  value = aws_subnet.api-subnets[0].id
}

output "db_subnet_id_bastion" {
  value = aws_subnet.db-subnets[1].id
}

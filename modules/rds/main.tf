# ########################################
# # new Postgress private instance
# # 
# resource "aws_db_subnet_group" "db-subnet-grp" {
#   name = "${var.prefix}-db-subnet-grp"
#   subnet_ids = [aws_subnet.db-subnets[1].id, db_subnet_id1.id]
#   # subnet_ids = [for i in var.db_subnet_ids : i.id]
#   description = "subnet group to allow Multi AZ for this instance"

#   tags = {
#     "Name" = "${var.prefix}-db-subnet-grp",
#     "cliente" = var.client,
#     "ambiente" = "dev"
#   }
# }

# resource "aws_db_instance" "db" {
#   # vpc_id = var.vpc_main_id
#   allocated_storage = 5
#   max_allocated_storage = 10
#   instance_class = "db.t3.micro"
#   engine = "postgres"
#   parameter_group_name = "default.postgres-14"
#   engine_version = "14.1-R1"
#   username = "d3bid"

#   db_name = "bid"

#   tags = {
#     "Name" = "${var.prefix}-db",
#     "cliente" = var.client,
#     "ambiente" = "dev"
#   }
# } 

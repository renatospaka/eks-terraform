module "vpc" {
  source = "./modules/vpc"
  prefix = var.prefix
  client = var.client

  web_subnets_size = var.web_subnets_size
  api_subnets_size = var.api_subnets_size
  db_subnets_size = var.db_subnets_size

  web_subnet_ids = module.vpc.web_subnet_ids
}

module "web-eks" {
  source = "./modules/eks/web"
  prefix = var.prefix
  client = var.client

  vpc_main_id = module.vpc.vpc_main_id

  retention_days = var.retention_days

  web_subnet_ids = module.vpc.web_subnet_ids
  web_cluster_name = var.web_cluster_name
  web_desired_size = var.web_desired_size
  web_max_size = var.web_max_size
  web_min_size = var.web_min_size
}

# module "ssh" {
#   source = "./modules/ssh"
#   prefix = var.prefix
#   client = var.client

#   ssh_key_name = var.ssh_key_name
# }

module "ec2" {
  source = "./modules/ec2"
  
  prefix = var.prefix
  client = var.client

  vpc_main_id = module.vpc.vpc_main_id
  
  # api_subnet_ids = module.vpc.api_subnet_ids
  # db_subnet_ids = module.vpc.db_subnet_ids  

  # # ssh_key_name = module.ssh.ssh_key_name
}
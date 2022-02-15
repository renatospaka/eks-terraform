module "vpc" {
  source = "./modules/vpc"
  prefix = var.prefix
  client = var.client

  web_subnets_size = var.web_subnets_size
  api_subnets_size = var.api_subnets_size
  db_subnets_size = var.db_subnets_size

  web_subnet_ids = module.vpc.web_subnet_ids
  web_subnet_id_bastion = module.vpc.web_subnet_id_bastion
  api_subnet_id_bastion = module.vpc.api_subnet_id_bastion
  db_subnet_id_bastion = module.vpc.db_subnet_id_bastion
}

module "eks" {
  source = "./modules/eks"
  prefix = var.prefix
  client = var.client

  vpc_main_id = module.vpc.vpc_main_id

  retention_days = var.retention_days

  web_subnet_ids = module.vpc.web_subnet_ids
  web_cluster_name = var.web_cluster_name
  web_desired_size = var.web_desired_size
  web_max_size = var.web_max_size
  web_min_size = var.web_min_size

  api_subnet_ids = module.vpc.api_subnet_ids
  api_cluster_name = var.api_cluster_name
  api_desired_size = var.api_desired_size
  api_max_size = var.api_max_size
  api_min_size = var.api_min_size
}


module "ec2" {
  source = "./modules/ec2"
  
  prefix = var.prefix
  client = var.client

  vpc_main_id = module.vpc.vpc_main_id
  
  web_subnet_id_bastion = module.vpc.web_subnet_id_bastion
  api_subnet_id_bastion = module.vpc.api_subnet_id_bastion
  db_subnet_id_bastion = module.vpc.db_subnet_id_bastion
  # # ssh_key_name = module.ssh.ssh_key_name
}

# module "ssh" {
#   source = "./modules/ssh"
#   prefix = var.prefix
#   client = var.client

#   ssh_key_name = var.ssh_key_name
# }

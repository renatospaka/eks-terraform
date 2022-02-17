terraform {
  # é a versão que os exemplos do terraform são feitos
  required_version = ">=0.13.1"
  required_providers {
    aws = ">=3.74.0"
    local = ">=2.1.0"
  }
  backend "s3" {
    bucket = "eks-2-cluster"
    key = "terraform.tfstate"
    region = "sa-east-1"
  }
}

provider "aws" {
  region = "sa-east-1"
}

module "vpc" {
  source = "./modules/vpc"
  prefix = var.prefix
  client = var.client

  web_subnets_size = var.web_subnets_size
  api_subnets_size = var.api_subnets_size
  db_subnets_size = var.db_subnets_size

  web_subnet_ids = module.vpc.web_subnet_ids
  # db_subnet_ids = module.vpc.db_subnet_ids

  # # db_subnet_id0 = module.vpc.db_subnet_id0
  # # db_subnet_id1 = module.vpc.db_subnet_id1

  web_subnet_id_bastion = module.vpc.web_subnet_id_bastion
  api_subnet_id_bastion = module.vpc.api_subnet_id_bastion
  db_subnet_id_bastion = module.vpc.db_subnet_id_bastion

  sg-developers = module.ec2.sg-developers
}

# module "eks" {
#   source = "./modules/eks"
#   prefix = var.prefix
#   client = var.client

#   vpc_main_id = module.vpc.vpc_main_id

#   retention_days = var.retention_days

#   web_subnet_ids = module.vpc.web_subnet_ids
#   web_cluster_name = var.web_cluster_name
#   web_desired_size = var.web_desired_size
#   web_max_size = var.web_max_size
#   web_min_size = var.web_min_size

#   api_subnet_ids = module.vpc.api_subnet_ids
#   api_cluster_name = var.api_cluster_name
#   api_desired_size = var.api_desired_size
#   api_max_size = var.api_max_size
#   api_min_size = var.api_min_size
# }

module "ec2" {
  source = "./modules/ec2"
  
  prefix = var.prefix
  client = var.client

  vpc_main_id = module.vpc.vpc_main_id
  
  web_subnet_id_bastion = module.vpc.web_subnet_id_bastion
  api_subnet_id_bastion = module.vpc.api_subnet_id_bastion
  db_subnet_id_bastion = module.vpc.db_subnet_id_bastion
}


## problems with Terraform objects that 
## exports lists in incompatible way with
## each other - unbelivable 
# module "rds" {
#   source = "./modules/rds"
  
#   prefix = var.prefix
#   client = var.client

#   vpc_main_id = module.vpc.vpc_main_id

#   # db_subnet_ids = module.vpc.db_subnet_ids
#   db_subnet_id0 = module.vpc.db_subnet_id0
#   db_subnet_id1 = module.vpc.db_subnet_id1
# }

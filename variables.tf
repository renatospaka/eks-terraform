variable "prefix" {}

variable "retention_days" {}

variable "web_cluster_name" {}
variable "web_subnets_size" {}
variable "web_desired_size" {}
variable "web_max_size" {}
variable "web_min_size" {}

variable "api_cluster_name" {}
variable "api_subnets_size" {}
variable "api_desired_size" {}
variable "api_max_size" {}
variable "api_min_size" {}

variable "db_subnets_size" {}

variable "client" {}
variable "region" {}

# variable "api_subnet_ids" {}
# variable "db_subnet_ids" {}

# variable "ssh_key_name" {}
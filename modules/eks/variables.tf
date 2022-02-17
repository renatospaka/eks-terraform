variable "vpc_main_id" {}

variable "prefix" {}
variable "client" {}

variable "retention_days" {}

variable "web_cluster_name" {}
variable "web_desired_size" {}
variable "web_max_size" {}
variable "web_min_size" {}
variable "web_subnet_ids" {}

variable "api_cluster_name" {}
variable "api_desired_size" {}
variable "api_max_size" {}
variable "api_min_size" {}
variable "api_subnet_ids" {}

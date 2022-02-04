terraform {
  # é a versão que os exemplos do terraform são feitos
  required_version = ">=0.13.1"
  required_providers {
    aws = ">=3.74.0"
    local = ">=2.1.0"
  }
}

provider "aws" {
  region = "sa-east-1"
}
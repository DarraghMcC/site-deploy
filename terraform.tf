variable "aws_region" {
  type = string
}

variable "www_domain_name" {
  type = string
}

variable "root_domain_name" {
  type = string
}

module "website" {
  source = "./deploy/terraform/static-site"
  www_domain_name = var.www_domain_name
  root_domain_name=var.root_domain_name
}

provider "aws" {
  version             = "2.58.0"
  region              = var.aws_region
}

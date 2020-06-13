// see set up for these assests at https://github.com/DarraghMcC/tf-states
terraform {
  backend "s3" {
    bucket         = "darraghmc.com.state"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "darraghmc-com-state-locks"
    encrypt        = true
  }
}
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
  aws_region=var.aws_region
}

provider "aws" {
  version             = "2.58.0"
  region              = var.aws_region
}

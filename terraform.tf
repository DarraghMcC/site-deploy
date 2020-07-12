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

variable "forward_emails" {
  type        = map(list(string))
  description = "Map of forward emails"
}

variable "relay_email" {
  type        = string
  description = "Email that used to relay from"
}

module "website" {
  source = "./deploy/terraform/static-site"
  www_domain_name = var.www_domain_name
  root_domain_name=var.root_domain_name
  aws_region=var.aws_region
}

module "ses_lambda_forwarder" {
  source    = "git::https://github.com/cloudposse/terraform-aws-ses-lambda-forwarder.git?ref=master"
  name="${var.root_domain_name}_forward_emails"
  region = var.aws_region
  domain = var.root_domain_name

  relay_email    = var.relay_email
  forward_emails = var.forward_emails
}

provider "aws" {
  version             = "2.58.0"
  region              = var.aws_region
}

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


variable "lambda_forwarder_runtime" {
  type        = string
  description = "Node version for the ses forwarder lambda to run"
}

variable "lambda_upload_bucket" {
  type        = string
  description = "Name of s3 bucket used for the email lambda upload" 
}

module "website" {
  source = "./deploy/terraform/static-site"
  www_domain_name = var.www_domain_name
  root_domain_name=var.root_domain_name
  aws_region=var.aws_region
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = "deploy/terraform/static-site/email-forwarder"
  output_path = "email-forwarder.zip"
}


resource "aws_s3_bucket" "lambda_bucket" {
  bucket = var.lambda_upload_bucket
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "file_upload" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "email-forwarder.zip"
  acl    = "public-read"
  source = data.archive_file.source.output_path
}

module "ses_lambda_forwarder" {
  source    = "git::https://github.com/cloudposse/terraform-aws-ses-lambda-forwarder.git?ref=master"
  name="${var.root_domain_name}_forward_emails"
  region = var.aws_region
  domain = var.root_domain_name
  lambda_runtime = var.lambda_forwarder_runtime

  relay_email    = var.relay_email
  forward_emails = var.forward_emails
  artifact_url = "https://${var.lambda_upload_bucket}.s3.amazonaws.com/${aws_s3_bucket_object.file_upload.id}"
  artifact_filename = "email-forwarder.zip"
}

provider "aws" {
  version             = "2.58.0"
  region              = var.aws_region
}

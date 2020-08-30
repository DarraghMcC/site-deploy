aws_region = "us-east-1"
www_domain_name="www.darraghmc.com"
root_domain_name="darraghmc.com"
forward_emails = {
  "info@darraghmc.com"  = ["darraghm.mccarthy@gmail.com"]
  "me@darraghmc.com" = ["darraghm.mccarthy@gmail.com"]
}
relay_email="darragh.m.mccarthy@gmail.com"
lambda_forwarder_runtime="nodejs12.x"
lambda_upload_bucket="email-forwarder-code"
# Terraform for www.Darraghmc.com infra

My personal website - `www.darraghmc.com`

Creates cloudfront distributiion backed by s3 bucket and relevant route53 A records.

## Handling non www version (darraghmc.com)
In order to have cloudfront handle the ssl certs for this site, have created a new CDN backed 
by an s3 bucket which is just a straight redirect to `www.darraghmc.com`.
I feel there is a better way of doing this - to explore later. 

## Email Forwarding
Email forwarding is handled by the cloud posse module [terraform-aws-ses-lambda-forwarder](https://github.com/cloudposse/terraform-aws-ses-lambda-forwarder). 
This module expects access to a lambda zip file containing code got [aws-lambda-ses-forwarder](https://www.npmjs.com/package/aws-lambda-ses-forwarder). 
The code for this node lambda is found here under deploy/terraform/static-site/email-forwarder. 

**Note the node_modules for this are not commited and ``npm i`` must be run before regenerating.**
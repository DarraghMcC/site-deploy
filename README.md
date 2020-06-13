# Terraform for www.Darraghmc.com infra

My personal website - `www.darraghmc.com`

Creates cloudfront distributiion backed by s3 bucket and relevant route53 A records.

## Handling non www version (darraghmc.com)
In order to have cloudfront handle the ssl certs for this site, have created a new CDN backed 
by an s3 bucket which is just a straight redirect `to www.darraghmc.com`.
I feel there is a better way of doing this - to explore later. 

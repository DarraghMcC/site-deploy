resource "aws_route53_zone" "primary" {
  name = var.root_domain_name
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name = var.www_domain_name
  type = "A"
  alias {
    name                    = aws_cloudfront_distribution.prod_distribution.domain_name
    zone_id                 = aws_cloudfront_distribution.prod_distribution.hosted_zone_id
    evaluate_target_health  = false
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name = "*.${var.root_domain_name}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

resource "aws_route53_record" "cert_validation" {
  name = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
  type = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  zone_id = aws_route53_zone.primary.zone_id
  records = [aws_acm_certificate.cert.domain_validation_options.0.resource_record_value]
  ttl = 60
}
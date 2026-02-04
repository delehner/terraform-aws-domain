data "aws_route53_zone" "selected_domain" {
  count = var.new_domain ? 0 : 1

  name         = var.domain
  private_zone = false
}

resource "aws_acm_certificate" "cert" {
  domain_name               = var.new_domain ? aws_route53_zone.domain[0].name : data.aws_route53_zone.selected_domain[0].name
  subject_alternative_names = ["*.${var.new_domain ? aws_route53_zone.domain[0].name : data.aws_route53_zone.selected_domain[0].name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "wild_card_cert" {
  domain_name       = "*.${var.new_domain ? aws_route53_zone.domain[0].name : data.aws_route53_zone.selected_domain[0].name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.new_domain ? aws_route53_zone.domain[0].zone_id : data.aws_route53_zone.selected_domain[0].zone_id
}

resource "aws_route53_record" "wild_card_cert" {
  for_each = {
    for dvo in aws_acm_certificate.wild_card_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.new_domain ? aws_route53_zone.domain[0].zone_id : data.aws_route53_zone.selected_domain[0].zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert : record.fqdn]
}

resource "aws_acm_certificate_validation" "wild_card_cert" {
  certificate_arn         = aws_acm_certificate.wild_card_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.wild_card_cert : record.fqdn]
}

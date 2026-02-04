output "hosted_zone_arn" {
  value       = var.new_domain ? aws_route53_zone.domain[0].arn : data.aws_route53_zone.selected_domain[0].arn 
  description = "The Route53 Hosted Zone ARN."
}

output "zone_id" {
  value       = var.new_domain ? aws_route53_zone.domain[0].zone_id : data.aws_route53_zone.selected_domain[0].zone_id
  description = "The zone_id for the hosted zone."
}

output "cert" {
  value       = aws_acm_certificate.cert
  description = "Certificate."
}

output "wild_card_cert" {
  value       = aws_acm_certificate.wild_card_cert
  description = "Wild card certificate."
}

resource "aws_route53_zone" "domain" {
  count = var.new_domain ? 1 : 0

  name = var.domain
}

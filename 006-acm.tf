module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 5.1.0"

  domain_name = var.domain
  zone_id     = data.aws_route53_zone.selected.zone_id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain}",
    "${var.project}-${var.env}.${var.domain}",
  ]

  wait_for_validation = true

}
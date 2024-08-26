module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 4.0"

  zone_name = var.domain

  records = [
    {
      name = "${var.project}-${var.env}"
      type = "A"
      alias = {
        name    = "dualstack.${module.alb.dns_name}"
        zone_id = module.alb.zone_id
      }
    }
  ]
}

# output "alb" {
#   value = module.alb
# }
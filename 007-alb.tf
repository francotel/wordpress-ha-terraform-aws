module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.11.0"

  name                       = "alb-${var.project}-${var.env}"
  vpc_id                     = module.networking.vpc_id
  subnets                    = module.networking.public_subnets
  enable_deletion_protection = false

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.networking.vpc_cidr_block
    }
  }

  #   access_logs = {
  #     bucket = "my-alb-logs"
  #   }

  listeners = {
    ex-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    ex-https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = module.acm.acm_certificate_arn

      forward = {
        target_group_key = "ex_asg"
      }
    }
  }

  target_groups = {
    ex_asg = {
      backend_protocol                  = "HTTP"
      backend_port                      = 80
      target_type                       = "instance"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      # There's nothing to attach here in this definition.
      # The attachment happens in the ASG module above
      create_attachment = false
    }
  }

}
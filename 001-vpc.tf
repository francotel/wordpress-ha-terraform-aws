# Definición de la primera VPC
module "networking" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "vpc-${var.project}-${var.env}"
  cidr = "172.16.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 2)

  private_subnets  = ["172.16.0.0/24", "172.16.1.0/24"]
  public_subnets   = ["172.16.2.0/24", "172.16.3.0/24"]
  database_subnets = ["172.16.4.0/24", "172.16.5.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  map_public_ip_on_launch = true

  public_subnet_tags = {
    orion = "public-subnet-${var.project}-1"
  }

  private_subnet_tags = {
    orion = "private-subnet-${var.project}-1"
  }
}

# module "vpc_endpoints" {
#   source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

#   vpc_id = module.networking.vpc_id

#   create_security_group      = true
#   security_group_name_prefix = "${var.project}-${var.env}-vpc-endpoints-"
#   security_group_description = "VPC endpoint security group"
#   security_group_rules = {
#     ingress_https = {
#       description = "HTTPS from VPC"
#       cidr_blocks = [module.networking.vpc_cidr_block]
#     }
#   }

#   endpoints = {
#     ssm = {
#       service    = "ssm"
#       subnet_ids = module.networking.private_subnets
#       # private_dns_enabled = true
#       # dns_options = {
#       #   private_dns_only_for_inbound_resolver_endpoint = false
#       # }
#       tags = { Name = "ssm-vpc-endpoint" }
#     },
#   }
# }
################################################################################
# ELASTICACHE Module
################################################################################

module "elasticache" {
  source  = "terraform-aws-modules/elasticache/aws"
  version = "1.2.2"

  cluster_id               = "memcached-${var.project}-${var.env}"
  create_cluster           = true
  create_replication_group = false

  engine          = "memcached"
  engine_version  = "1.6.17"
  node_type       = "cache.t4g.small"
  num_cache_nodes = 2
  az_mode         = "cross-az"

  maintenance_window = "sun:05:00-sun:09:00"
  apply_immediately  = true

  # Security group
  vpc_id = module.networking.vpc_id
  security_group_rules = {
    ingress_vpc = {
      # Default type is `ingress`
      # Default port is based on the default engine port
      description = "VPC traffic"
      cidr_ipv4   = module.networking.vpc_cidr_block
    }
  }

  #create_subnet_group
  # Subnet Group
  subnet_ids = module.networking.database_subnets

  # Parameter Group
  create_parameter_group = true
  parameter_group_family = "memcached1.6"
  parameters = [
    {
      name  = "idle_timeout"
      value = 60
    }
  ]

}
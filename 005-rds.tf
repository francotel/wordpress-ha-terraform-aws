################################################################################
# RDS Module
################################################################################

module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.9.0"

  name            = "rds-${var.project}-${var.env}"
  engine          = "aurora-mysql"
  engine_version  = "8.0"
  master_username = "wordpress_admin"
  instance_class  = "db.t3.medium"
  instances = {
    1 = {
    }
    2 = {
    }
  }
  database_name        = "wordpress_db"
  vpc_id               = module.networking.vpc_id
  db_subnet_group_name = module.networking.database_subnet_group_name
  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = module.networking.private_subnets_cidr_blocks
    }
  }

  apply_immediately   = true
  skip_final_snapshot = true

  create_db_cluster_parameter_group      = true
  db_cluster_parameter_group_name        = "pg-cluster-${var.project}-${var.env}"
  db_cluster_parameter_group_family      = "aurora-mysql8.0"
  db_cluster_parameter_group_description = "pg-cluster-${var.project}-${var.env} cluster parameter group"
  db_cluster_parameter_group_parameters = [
    {
      name         = "connect_timeout"
      value        = 120
      apply_method = "immediate"
    }
  ]

  create_db_parameter_group      = true
  db_parameter_group_name        = "pg-${var.project}-${var.env}"
  db_parameter_group_family      = "aurora-mysql8.0"
  db_parameter_group_description = "pg-${var.project}-${var.env} DB parameter group"
  db_parameter_group_parameters = [
    {
      name         = "connect_timeout"
      value        = 60
      apply_method = "immediate"
    }
  ]

  enabled_cloudwatch_logs_exports      = ["audit", "error", "general", "slowquery"]
  create_db_cluster_activity_stream    = false
  manage_master_user_password_rotation = false
  #   master_user_password_rotation_schedule_expression = "rate(15 days)"
  backup_retention_period  = "15"
  delete_automated_backups = true

}
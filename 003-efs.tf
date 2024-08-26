################################################################################
# EFS Module
################################################################################

module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.6.3"

  # File system
  name             = "efs-${var.project}-${var.env}"
  creation_token   = "${var.project}-${var.env}-efs-token"
  encrypted        = true
  kms_key_arn      = module.kms.key_arn
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  #   lifecycle_policy = {
  #     transition_to_ia = "AFTER_30_DAYS"
  #   }

  # Mount targets / security group
  mount_targets = {
    "${module.networking.azs.0}" = {
      subnet_id = module.networking.database_subnets[0]
    }
    "${module.networking.azs.1}" = {
      subnet_id = module.networking.database_subnets[1]
    }
  }

  security_group_description = "EFS security group - ${var.project} ${var.env}"
  security_group_vpc_id      = module.networking.vpc_id
  security_group_rules = {
    vpc = {
      # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC private subnets"
      cidr_blocks = module.networking.private_subnets_cidr_blocks #["10.99.3.0/24", "10.99.4.0/24", "10.99.5.0/24"]
    }
  }

  # Backup policy
  enable_backup_policy = false

  # Replication configuration
  create_replication_configuration = false
  replication_configuration_destination = {
    # region = "eu-west-2"
  }

}
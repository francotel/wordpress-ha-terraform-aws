data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
data "aws_subnets" "public" {}

data "aws_ami" "latest_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*amzn2-ami-hvm-*"] # Filtra por AMIs de Amazon Linux 2
  }

  filter {
    name   = "architecture"
    values = ["x86_64"] # Filtra por arquitectura x86_64 (64-bit)
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"] # Filtra por AMIs respaldadas por EBS (Elastic Block Store)
  }
}

data "aws_route53_zone" "selected" {
  name = "${var.domain}."
}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.current.name
}
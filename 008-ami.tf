# module "iam_policy" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
#   version = "~> 5.44"

#   name        = "ec2-secretsmanager-access"
#   path        = "/"
#   description = "Policy to allow EC2 to read secrets from AWS Secrets Manager"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "secretsmanager:GetSecretValue",
#         "secretsmanager:DescribeSecret",
#         "secretsmanager:ListSecretVersionIds"
#       ],
#       "Effect": "Allow",
#       "Resource": "${module.aurora.cluster_master_user_secret[0].secret_arn}"
#     }
#   ]
# }
# EOF
# }

# data "template_file" "user_data" {
#   template = file("${path.module}/scripts/init-aml2.sh")
#   vars = {
#     EFS_ID       = module.efs.dns_name
#     DB_NAME      = module.aurora.cluster_database_name
#     DB_HOSTNAME  = module.aurora.cluster_endpoint
#     DB_USERNAME  = module.aurora.cluster_master_username
#     DB_SECRET_ID = module.aurora.cluster_master_user_secret[0].secret_arn #data.aws_secretsmanager_secret_version.secret_version.secret_string #jsondecode(data.aws_secretsmanager_secret_version.secret_version.secret_string)["password"]
#     SUBDOMAIN    = "${var.project}-${var.env}.${var.domain}"
#     WP_TITLE     = "HA Wordpress on AWS with Terraform"
#     WP_ADMIN     = "wordpressadmin"
#     WP_PASSWORD  = "wordpressadmin"
#     WP_EMAIL     = "admin@wordpress.com"
#     AWS_REGION   = local.aws_region
#     WP_VERSION   = "6.1"
#     LOCALE       = "en_GB"
#   }
# }

data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

module "ec2_demo" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  name               = "ec2-${var.project}-${var.env}"
  ami                = data.aws_ami.amazon-2.id
  ignore_ami_changes = false
  instance_type      = "t3a.micro"
  subnet_id          = element(module.networking.public_subnets, 0)
  key_name           = "kp-demo-test"
  #vpc_security_group_ids = [module.ssh_service_sg.security_group_id]
  #   user_data                   = data.template_file.user_data.rendered
  #   user_data_replace_on_change = true

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  #enable_volume_tags = false
  #   root_block_device = [
  #     {
  #       encrypted   = true
  #       volume_type = "gp3"
  #       throughput  = 200
  #       volume_size = 20
  #       tags = {
  #         Name = "my-root-block"
  #       }
  #     },
  #   ]
  metadata_options = {
    http_tokens = "required"
  }
}

# # resource "null_resource" "sleep_before_ami" {
# #   provisioner "local-exec" {
# #     command = "sleep 300" # 300 segundos = 5 minutos
# #   }

# #   depends_on = [module.ec2_demo]
# # }

# # resource "aws_ami_from_instance" "ami_demo" {
# #   name               = "ami-build-${var.project}-${var.env}"
# #   source_instance_id = module.ec2_demo.id
# #   lifecycle {
# #     create_before_destroy = true
# #   }

# #   tags = {
# #     Name = "ami-build-${var.project}-${var.env}"
# #   }
# # }

# # resource "null_resource" "terminate_instance" {
# #   depends_on = [module.ec2_demo]

# #   provisioner "local-exec" {
# #     command = "aws ec2 terminate-instances --instance-ids ${module.ec2_demo.id}"
# #   }
# # }

# module "ssh_service_sg" {
#   source = "terraform-aws-modules/security-group/aws"

#   name        = "user-service"
#   description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
#   vpc_id      = module.networking.vpc_id

#   ingress_cidr_blocks = [module.networking.vpc_cidr_block]
#   ingress_rules       = ["ssh-tcp"]
# }
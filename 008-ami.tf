module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 5.44"

  name        = "ec2-secretsmanager-access"
  path        = "/"
  description = "Policy to allow EC2 to read secrets from AWS Secrets Manager"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
      ],
      "Effect": "Allow",
      "Resource": "${module.aurora.cluster_master_user_secret[0].secret_arn}"
    }
  ]
}
EOF
}

data "template_file" "user_data" {
  template = file("${path.module}/scripts/init-aml2.sh")
  vars = {
    EFS_ID       = module.efs.dns_name
    DB_NAME      = module.aurora.cluster_database_name
    DB_HOSTNAME  = module.aurora.cluster_endpoint
    DB_USERNAME  = module.aurora.cluster_master_username
    DB_SECRET_ID = module.aurora.cluster_master_user_secret[0].secret_arn
    SUBDOMAIN    = "${var.project}-${var.env}.${var.domain}"
    WP_TITLE     = "HA Wordpress on AWS with Terraform"
    WP_ADMIN     = "wordpressadmin"
    WP_PASSWORD  = "wordpressadmin"
    WP_EMAIL     = "admin@wordpress.com"
    AWS_REGION   = local.aws_region
    WP_VERSION   = "6.6.1"
    LOCALE       = "en_GB"
  }
  depends_on = [
    module.aurora
  ]
}

data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}
################################################################################
# KMS Module
################################################################################

module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.5"

  aliases               = ["efs/kms-${var.project}-${var.env}"]
  description           = "${var.project}-${var.env} efs encryption key"
  enable_default_policy = true
  key_owners            = [local.aws_account_id]

  key_statements = [
    {
      sid = "Allow access through EBS for all principals in the account that are authorized to use EBS"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:CreateGrant",
        "kms:DescribeKey"
      ]
      resources = ["*"]

      principals = [
        {
          type        = "AWS"
          identifiers = ["*"]
        }
      ]

      conditions = [
        {
          test     = "StringEquals"
          variable = "kms:ViaService"
          values = [
            "elasticfilesystem.amazonaws.com",
          ]
        },
        {
          test     = "StringEquals"
          variable = "kms:CallerAccount"
          values = [
            local.aws_account_id
          ]
        }
      ]
    }
  ]

}
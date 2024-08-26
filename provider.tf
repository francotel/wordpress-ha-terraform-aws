provider "aws" {
  # profile = var.profile # managment account local aws credential/config profile name

  # Common tags for all resources that accept tags
  default_tags {
    tags = {
      ManagedBy         = "Terraform"
      Env               = var.env
      Terraform-Version = var.tf_version
      Cost              = var.cost
      Owner             = var.owner
      Project           = var.project
    }
  }
}
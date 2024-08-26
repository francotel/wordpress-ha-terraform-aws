terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.2" # verifiy version on https://registry.terraform.io/providers/hashicorp/aws/latest
    }
  }
}
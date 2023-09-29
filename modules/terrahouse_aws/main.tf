terraform {
  cloud {
    organization = "beginner-bootcamp"
    workspaces {
      name = "terra-house-1"
    }
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
data "aws_caller_identity" "current" {}
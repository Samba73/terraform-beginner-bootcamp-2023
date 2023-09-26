terraform {
#   cloud {
#     organization = "beginner-bootcamp"
#     workspaces {
#       name = "terra-house-1"
#     }
#   }
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}
# Configure the AWS provider
provider "aws" {}

# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string

provider "random" {
  # Configuration options
}
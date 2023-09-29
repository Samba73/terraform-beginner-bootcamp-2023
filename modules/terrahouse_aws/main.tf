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

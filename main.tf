terraform {
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
provider "aws" {
  # Configuration options
}

# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string

provider "random" {
  # Configuration options
}
resource "random_string" "bucket_name" {
  length           = 16
  special          = false
  upper            = false 
}

# Define s3 in terraform
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

# s3 naming rules
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html

resource "aws_s3_bucket" "example" {
  bucket = "samba07-tf-${random_string.bucket_name.result}"
}

output "random_bucket_name" {
  value = random_string.bucket_name.result
}
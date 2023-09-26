
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

  tags = {
    "Created_By" = var.user_uuid
  }
}


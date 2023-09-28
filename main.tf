
# Define s3 in terraform
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

# s3 naming rules
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    "Created_By" = var.user_uuid
  }
}


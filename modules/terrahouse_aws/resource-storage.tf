 # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
 # Bucket Naming Rules
    #https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html?icmpid=docs_amazons3_console

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    "Created_By" = var.user_uuid
  }
}

resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "terraform_data" "content_version" {
  input = var.content_version
}

resource "aws_s3_object" "index_html" {
  bucket        = aws_s3_bucket.website_bucket.bucket
  key           = "index.html"
  source        = "${var.public_path}/index.html"
  content_type  = "text/html"
  etag          = filemd5("${var.public_path}/index.html")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "error_html" {
  bucket        = aws_s3_bucket.website_bucket.bucket
  key           = "error.html"
  source        = "${var.public_path}/error.html"
  content_type  = "text/html"
  etag          = filemd5("${var.public_path}/error.html")
}

resource "aws_s3_object" "assets_upload" {
  for_each      = fileset("${var.public_path}/assets","*.{jpg,png,gif}")
  bucket        = aws_s3_bucket.website_bucket.bucket
  key           = "assets/${each.key}" 
  source        = "${var.public_path}/assets/${each.key}"
  etag         = filemd5("${var.public_path}/assets/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
# https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html

resource "aws_s3_bucket_policy" "cf_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": {
        "Sid": "AllowCloudFrontServicePrincipalReadOnly",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.website_bucket.id}/*",
        "Condition": {
            "StringEquals": {
                # "AWS:SourceArn": "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
                "AWS:SourceArn": aws_cloudfront_distribution.s3_distribution.arn
            }
        }
    }
}
  )
}
output "s3_bucket_name" {
  value = aws_s3_bucket.website_bucket
}

output "s3_website_url" {
  value = aws_s3_bucket_website_configuration.website_configuration.website_endpoint
}
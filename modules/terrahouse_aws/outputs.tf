output "s3_bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket
}

output "s3_website_url" {
  value = aws_s3_bucket_website_configuration.website_configuration.website_endpoint
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

# output "home_id" {
#   value = {
#     pac-man_home_id  = terratowns_home.pac-man.id
#     crepe_home_id    = terratowns_home.crepe.id
#   }
# }
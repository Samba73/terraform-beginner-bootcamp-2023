/*
output "s3_bucket_name" {
  value = module.terrahouse_aws.s3_bucket_name
}

output "s3_website_url" {
  value = module.terrahouse_aws.s3_website_url
}

output "cloudfront_url" {
  value = module.terrahouse_aws.cloudfront_url
}
*/

output "home_id" {
  value = terratowns_home.home.id
}

# output "s3_bucket_name" {
#   value = module.terrahouse_aws.s3_bucket_name
# }

# output "s3_website_url" {
#   value = module.terrahouse_aws.s3_website_url
# }

# output "cloudfront_url" {
#   value = module.terrahouse_aws.cloudfront_url
# }
# output "home_id" {
#   value = terratowns_home.home.id
# }

output "pac-man" {
  value  = {
    s3_bucket_name = module.pac-man.s3_bucket_name,
    s3_website_url = module.pac-man.s3_website_url,
    cloudfront_url = module.pac-man.cloudfront_url,
    home_id        = terratowns_home.pac-man.id
  }
}   
output "crepe" {
  value  = {
    s3_bucket_name = module.crepe.s3_bucket_name,
    s3_website_url = module.crepe.s3_website_url,
    cloudfront_url = module.crepe.cloudfront_url,
    home_id        = terratowns_home.crepe.id
  }
}  
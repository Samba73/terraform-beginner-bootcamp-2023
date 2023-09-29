# terraform {
#   cloud {
#     organization = "beginner-bootcamp"
#     workspaces {
#       name = "terra-house-1"
#     }
#   }
# }  
module "terrahouse_aws" {
  source                = "./modules/terrahouse_aws"
  user_uuid             = var.user_uuid  
  s3_bucket_name        = var.s3_bucket_name
  index_html_path       = var.index_html_path
  error_html_path       = var.error_html_path 
  content_version       = var.content_version 
  }


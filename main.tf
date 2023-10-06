# terraform {
#   cloud {
#     organization = "beginner-bootcamp"
#     workspaces {
#       name = "terra-house-1"
#     }
#   }
# } 
terraform {
  required_providers {
  terratowns = {
    source = "local.providers/local/terratowns"
    version = "1.0.0"
  }
}
}

provider "terratowns" {

  endpoint_url    = "http://localhost:4567/api"
  user_uuid       = "e328f4ab-b99f-421c-84c9-4ccea042c7d1"
  token           = "9b49b3fb-b8e9-483c-b703-97ba88eef8e0"

}

resource "terratowns_home" "home" {

  name            = "To test the Create home.Back here."
  description     = <<DESCRIPTION
                      This is HEREDOC entry for multi line description.
                      I would have to think about a Terra Home name and Town
                      to add my home. This is now only a test. Going well.!!!.

                      DESCRIPTION
  domain_name     = "3fdq3gz.cloudfront.net"
  town            = "gamers-grotto"
  content_version = 1
}


# module "terrahouse_aws" {
#   source                = "./modules/terrahouse_aws"
#   user_uuid             = var.user_uuid  
#   s3_bucket_name        = var.s3_bucket_name
#   index_html_path       = var.index_html_path
#   error_html_path       = var.error_html_path 
#   content_version       = var.content_version 
#   assets_path           = var.assets_path
#   }


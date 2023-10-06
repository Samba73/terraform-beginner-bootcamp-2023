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

  endpoint_url    = var.terratowns_endpoint
  user_uuid       = var.user_uuid
  token           = var.terratowns_access_token

}

resource "terratowns_home" "home" {

  name            = "Pac-Man: The Eternal Feast"
  description     = <<DESCRIPTION
                      Enter the mesmerizing world of Pac-Mania, where you control the iconic yellow hero on an endless quest to munch his way through mazes filled with colorful dots.
                      Dodge the mischievous ghosts, gobble power pellets, and embark on an epic adventure that blends classic arcade nostalgia with modern twists. 
                      Can you conquer the ever-changing labyrinth and become the ultimate Dot Devourer?
                      DESCRIPTION
  domain_name     = module.terrahouse_aws.cloudfront_url
  town            = var.terratowns_town
  content_version = 1
}


module "terrahouse_aws" {
  source                = "./modules/terrahouse_aws"
  user_uuid             = var.user_uuid  
  s3_bucket_name        = var.s3_bucket_name
  index_html_path       = var.index_html_path
  error_html_path       = var.error_html_path 
  content_version       = var.content_version 
  assets_path           = var.assets_path
  }


terraform {
  cloud {
    organization = "beginner-bootcamp"
    workspaces {
      name = "terra-house-1"
    }
  }
} 
terraform {
  required_providers {
  terratowns = {
    source = "local.providers/local/terratowns"
    version = "1.0.0"
  }
}
}

provider "terratowns" {

  endpoint_url    = var.terratowns_schema.endpoint

  user_uuid       = var.user_uuid
  token           = var.access_token


}

module "pac-man" {
  
  source                = "./modules/terrahouse_aws"

  user_uuid             = var.user_uuid

  s3_bucket_name        = var.s3_bucket_name.pac-man
  public_path           = var.pac-man.public_path 
  content_version       = var.pac-man.content_version 
  
  }

resource "terratowns_home" "pac-man" {

  name            = "Pac-Man: The Eternal Feast"
  description     = <<DESCRIPTION
                      Enter the mesmerizing world of Pac-Mania, where you control the iconic yellow hero on an endless quest to munch his way through mazes filled with colorful dots.
                      Dodge the mischievous ghosts, gobble power pellets, and embark on an epic adventure that blends classic arcade nostalgia with modern twists. 
                      Can you conquer the ever-changing labyrinth and become the ultimate Dot Devourer?
                      DESCRIPTION
  domain_name     = module.pac-man.cloudfront_url
  town            = var.terratowns_schema.town
  content_version = var.pac-man.content_version 
}


module "crepe" {
  source                = "./modules/terrahouse_aws"

  user_uuid             = var.user_uuid

  s3_bucket_name        = var.s3_bucket_name.crepe
  public_path           = var.crepe.public_path 
  content_version       = var.crepe.content_version 
  
  }

resource "terratowns_home" "crepe" {

  name            = "Indulge in the rich, velvety delight of chocolate crepes, a heavenly treat for your taste buds."
  description     = <<DESCRIPTION
                      Satisfy your sweet cravings with our delectable chocolate crepes. 
                      These thin, luscious pancakes are made with a cocoa-infused batter, resulting in a decadent, melt-in-your-mouth experience. 
                      Whether filled with chocolate chips, fresh berries, or a dollop of whipped cream, our chocolate crepes are a delightful dessert or breakfast option that will leave you craving for more. 
                      Enjoy the perfect blend of rich chocolate flavor and delicate pancake texture with every bite. Elevate your culinary journey and indulge in the ultimate chocolate lover's delight.
                      DESCRIPTION
  domain_name     = module.crepe.cloudfront_url
  town            = var.terratowns_schema.town
  content_version = var.crepe.content_version
}



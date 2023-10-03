terraform {
  cloud {
    organization = "beginner-bootcamp"
    workspaces {
      name = "terraform-cloud"
    }
  }
}  
module "terrahouse_aws" {
  source                = "./modules/terrahouse_aws"
  user_uuid             = var.user_uuid
  s3_bucket_name        = var.s3_bucket_name
  index_html_path       = "${path.root}${var.index_html_path}"
  error_html_path       = "${path.root}${var.error_html_path}"
  }


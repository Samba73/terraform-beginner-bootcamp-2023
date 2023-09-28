

module "terrahouse_aws" {
  source         = "./modules/terrahouse_aws"
  user_uuid      = var.user_uuid  
  s3_bucket_name = var.s3_bucket_name

  }


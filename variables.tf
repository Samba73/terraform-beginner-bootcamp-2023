
variable "terratowns_schema" {
  type        = object({
    //access_token = string
    endpoint     = string

  //  town         = string

    //user_uuid    = string 
  })
}
variable "user_uuid" {}
variable "access_token" {}


variable "s3_bucket_name" {
  description = "The bucket name for the website"
  type        = object({
    pac-man   = string
    crepe     = string
  })
}

variable "pac-man" {
  type        = object({
    public_path = string
    content_version = number 
    town = string
  })
}

variable "crepe" {
  type        = object({
    public_path = string
    content_version = number 
    town = string
  })
}
variable "terratowns_access_token" {
  type        = string 
}
variable "terratowns_endpoint" {
  type        = string 
}
variable "terratowns_town" {
  type        = string 
}
variable "user_uuid" {
  description = "The user UUID who created this bucket"
  type        = string
}

variable "s3_bucket_name" {
  description = "The bucket name for the website"
  type        = string
}
variable "index_html_path" {
  description = "Path to index.html file for static website"
}
variable "error_html_path" {
  description = "Path to error.html file for static website"
}
variable "content_version" {
  description = "A positive integer starting from 1"
  type        = number
}
variable "assets_path" {
  description = "Path to a file"
  type        = string
}
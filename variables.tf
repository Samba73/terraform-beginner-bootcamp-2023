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
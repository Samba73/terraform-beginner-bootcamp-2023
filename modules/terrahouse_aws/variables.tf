variable "user_uuid" {
    description     = "The UUID of user who created to s3 bucket"
    type            = string
    validation {
      condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$", var.user_uuid))
      error_message = "The value for variable user_uuid is missing / not valid"
    }
}
variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string

  validation {
    condition     = (can(regex("^[a-z0-9.-]{3,63}$", var.s3_bucket_name)) && 
                    length(var.s3_bucket_name) >=3 && length(var.s3_bucket_name) <=63)
    error_message = "S3 bucket name must be between 3 and 63 characters, contain only lowercase letters, numbers, hyphens, and periods, and not start or end with a hyphen or period. IP address format is not allowed."
  }
}

# variable "index_html_path" {
#   description = "Path to index.html file for static website"
#   validation {
#     condition = fileexists(var.index_html_path)
#     error_message = "The specified index.html file does not exists..."
#   }
# }

# variable "error_html_path" {
#   description = "Path to error.html file for static website"
#   validation {
#     condition = fileexists(var.error_html_path)
#     error_message = "The specified error.html file does not exists..."
#   }
# }

variable "public_path" {
  description = "Path to content for the home"
  validation {
    condition = fileexists("${var.public_path}/index.html")
    error_message = "The specified path does not contain expected content..."
  }
}

variable "content_version" {
  description = "A positive integer starting from 1"
  type        = number

  validation {
    condition     = var.content_version > 0 && floor(var.content_version) == var.content_version
    error_message = "The value must be a positive integer starting from 1."
  }
}

# variable "assets_path" {
#   description = "Path to a file"
#   type        = string
# }


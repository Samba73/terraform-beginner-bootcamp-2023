variable "user_uuid" {
    description = "The UUID of user who created to s3 bucket"
    type        = string
    validation {
      condition = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$", var.user_uuid))
      error_message = "The value for variable user_uuid is missing / not valid"
    }
}
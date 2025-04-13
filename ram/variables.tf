variable "name" {
  description = "The name of the SNS topic to create"
  type        = string

  validation {
    condition     = var.name == null ? false : length(var.name) > 0 && length(var.name) <= 256
    error_message = "The name of the SNS topic must be between 1 and 256 characters in length"
  }
}

variable "resource_arns" {
  type        = list(string)
  description = "List of resource arns to be shared"

  validation {
    condition     = var.resource_arns == null ? false : length(var.resource_arns) > 0
    error_message = "Resource Arns cannot be empty"
  }
}

variable "principal_arns" {
  type        = list(string)
  description = "List of principal arns to whom to share the resources to. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN."
  validation {
    condition     = var.principal_arns == null ? false : length(var.principal_arns) > 0
    error_message = "Principal Arns cannot be empty"
  }
}


variable "required_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}


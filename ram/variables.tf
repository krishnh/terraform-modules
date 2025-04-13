variable "name" {
  description = "The name of the resource share to create"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "name cannot be empty"
  }
}

variable "resource_arns" {
  type        = list(string)
  description = "List of resource arns to be shared"

  validation {
    condition     = length(var.resource_arns) > 0
    error_message = "Resource Arns cannot be empty"
  }
}

variable "principal_arns" {
  type        = list(string)
  description = "List of principal arns to whom to share the resources to. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
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


################################################################################
# Topic
################################################################################

variable "name" {
  description = "The name of the SNS topic to create"
  type        = string

  validation {
    condition     = var.name == null ? false : length(var.name) > 0 && length(var.name) <= 256
    error_message = "The name of the SNS topic must be between 1 and 256 characters in length"
  }
}

variable "display_name" {
  description = "The display name for the SNS topic"
  type        = string

  validation {
    condition     = var.display_name == null ? false : length(var.display_name) > 0 && length(var.display_name) <= 100
    error_message = "The display name of the SNS topic must be less than or equal to 100 characters in length"
  }
}

variable "kms_master_key_id" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK"
  type        = string
  default     = null

  validation {
    condition     = var.kms_master_key_id != null
    error_message = "The KMS master key ID must be provided"
  }
}


################################################################################
# Topic Policy
################################################################################

variable "access_policy_statements" {
  description = "A list of policy statements defining the permissions for the SNS topic"
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    principals = list(object({
      type        = string
      identifiers = list(string)
    }))
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })), [])
  }))

  default = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}

  // tags should not start with 'aws:' or 'bank:'
  validation {
    condition     = alltrue([for key, value in var.tags : !can(regex("^aws:.*|^bank:.*", key))])
    error_message = "Tags starting with 'aws:' or 'bank:' are reserved for internal use"
  }
}

################################################################################
# Subscription(s)
################################################################################

variable "subscriptions" {
  description = "A map of subscription definitions to create"
  type = list(object({
    protocol = string
    endpoint = string
  }))
  default = []

  // protocol must be either "https", "email", "email-json", "sms", "sqs", "application", or "lambda"
  validation {
    condition     = alltrue([for subscription in var.subscriptions : can(index(["https", "email", "email-json", "sms", "sqs", "application", "lambda"], subscription.protocol))])
    error_message = "The protocol of the subscription must be either 'https', 'email', 'email-json', 'sms', 'sqs', 'application', or 'lambda'"
  }

  // endpoint must be a non-empty string
  validation {
    condition     = alltrue([for subscription in var.subscriptions : subscription.endpoint == null ? false : length(subscription.endpoint) > 0])
    error_message = "The endpoint of the subscription must be a non-empty string"
  }
}
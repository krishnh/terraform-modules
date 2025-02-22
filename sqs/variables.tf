################################################################################
# Queue Configuration
################################################################################

variable "name" {
  type        = string
  description = "The name of the queue"

  validation {
    condition     = var.name != null ? length(var.name) > 0 && length(var.name) <= 80 : false
    error_message = "The name of the queue must be between 1 and 80 characters in length"
  }
}

variable "kms_master_key_id" {
  description = "The ARN of an AWS-managed or customer master key (CMK) for Amazon SNS"
  type        = string
  default     = null

  validation {
    condition     = var.kms_master_key_id != null
    error_message = "The KMS master key ID must be provided"
  }
}

variable "delay_seconds" {
  type        = number
  description = "The time in seconds that the delivery of all messages in the queue will be delayed"
  default     = 0

  validation {
    condition     = var.delay_seconds >= 0 && var.delay_seconds <= 900
    error_message = "The delay_seconds must be between less than 15 minutes (900 seconds)"
  }

}

variable "max_message_size" {
  type        = number
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it"
  default     = 262144

  validation {
    condition     = var.max_message_size >= 1024 && var.max_message_size <= 262144
    error_message = "The max_message_size must be between 1KB and 256KB"
  }

}

variable "message_retention_seconds" {
  type        = number
  description = "The number of seconds Amazon SQS retains a message"
  default     = 345600

  validation {
    condition     = var.message_retention_seconds >= 60 && var.message_retention_seconds <= 1209600
    error_message = "The message_retention_seconds must be between 1 minute and 14 days"
  }


}

variable "receive_wait_time_seconds" {
  type        = number
  description = "The time for which a ReceiveMessage call will wait for a message to arrive"
  default     = 20 # for long polling

  validation {
    condition     = var.receive_wait_time_seconds >= 0 && var.receive_wait_time_seconds <= 20
    error_message = "The receive_wait_time_seconds must be between 0 and 20 seconds"
  }
}


################################################################################
# Tagging
################################################################################

variable "required_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}

  // tags should not start with 'aws:' or 'bank:'
  validation {
    condition     = alltrue([for key, value in var.additional_tags : !can(regex("^aws:.*|^bank:.*", key))])
    error_message = "Tags starting with 'aws:' or 'bank:' are reserved for internal use"
  }
}


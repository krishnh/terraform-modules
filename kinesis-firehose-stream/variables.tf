variable "name" {
  description = "(Required) A name to identify the firehose stream"
  type        = string
  validation {
    condition     = length(var.name) > 1
    error_message = "The name of the fireshost stream must not be empty"
  }
}

variable "role_arn" {
  description = "(Required) The ARN of the IAM role that Kinesis Firehose can assume to access the data stream, S3 bucket, or other destination"
  type        = string
}

variable "destination" {
  description = "(Required) The destination for the Kinesis Firehose stream. Can be 'extended_s3', 'splunk'"
  type        = string

  validation {
    condition     = can(index(["extended_s3", "splunk"], var.destination))
    error_message = "The destination must be either 'extended_s3', 'splunk'"
  }
}

variable "kinesis_data_stream_arn" {
  description = "(Required) The ARN of the Kinesis Data Stream to use as the source for the Kinesis Firehose stream"
  type        = string
}


variable "s3_destination_configuration" {
  description = "(Optional) The S3 destination configuration for the Kinesis Firehose stream"
  type = object({
    bucket_arn          = string
    buffering_interval  = optional(number, 300)
    buffering_size      = optional(number, 5)
    compression_format  = optional(string, "UNCOMPRESSED")
    prefix              = string
    error_output_prefix = string
    kms_key_arn         = optional(string, null)
    custom_time_zone    = optional(string, "UTC")
    s3_backup_mode      = optional(string, "Disabled")
  })
  default = null
}

variable "splunk_destination_configuration" {
  description = "(Optional) The Splunk destination configuration for the Kinesis Firehose stream"
  type = object({
    hec_endpoint               = string
    hec_endpoint_type          = optional(string, "Raw")
    hec_acknowledgment_timeout = optional(number, 600)
    retry_duration             = optional(number, 300)
    s3_backup_mode             = optional(string, "FailedEventsOnly")
    hec_token_secret_arn       = string
    buffering_interval         = optional(number, 60)
    buffering_size             = optional(number, 5)
  })
  default = null
}


variable "cloudwatch_logging_options" {
  description = "(Optional) The CloudWatch logging options for the Kinesis Firehose stream"
  type = object({
    enabled         = optional(bool, false)
    log_group_name  = optional(string, null)
    log_stream_name = optional(string, null)
  })
  default = null
}


variable "backup_s3_configuration" {
  description = "(Optional) The S3 backup configuration for the Kinesis Firehose stream"
  type = object({
    bucket_arn          = string
    buffering_interval  = optional(number, 300)
    buffering_size      = optional(number, 5)
    compression_format  = optional(string, "UNCOMPRESSED")
    prefix              = string
    error_output_prefix = string
    kms_key_arn         = optional(string, null)
  })
  default = null
}


variable "processing_configuration" {
  description = "(Optional) The processing configuration for the Kinesis Firehose stream"
  type = object({
    enabled = optional(bool, false)
    processors = optional(list(object({
      type = string
      parameters = list(object({
        parameter_name  = string
        parameter_value = string
      }))
    })), [])
  })
  default = null
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


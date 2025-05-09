variable "name" {
  description = "(Required) A name to identify the stream"
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "The name of the SNS topic must not be empty"
  }
}

variable "shard_count" {
  description = "(Optional) The number of shards that the stream will use"
  type        = number
  default     = 1
}

variable "retention_period" {
  description = "(Optional) Length of time data records are accessible after they are added to the stream. The maximum value of a stream's retention period is 8760 hours. Minimum value is 24."
  type        = number
  default     = 24

  validation {
    condition     = var.retention_period >= 24 && var.retention_period <= 8760
    error_message = "The retention period must be between 24 and 8760 hours"
  }
}

variable "capacity_mode" {
  description = "(Optional) The capacity mode of the stream. Can be either 'PROVISIONED' or 'ON_DEMAND'."
  type        = string
  default     = "PROVISIONED"

  validation {
    condition     = can(index(["PROVISIONED", "ON_DEMAND"], var.capacity_mode))
    error_message = "The capacity mode must be either 'PROVISIONED' or 'ON_DEMAND'"
  }
}

variable "encryption_type" {
  description = "The name of the kinesis data stream to create"
  type        = string
  default     = "KMS"

  validation {
    condition     = can(index(["KMS", "NONE"], var.encryption_type))
    error_message = "The encryption type must be either 'KMS' or 'NONE'"
  }
}

variable "shard_level_metrics" {
  description = "(Optional) The shard level metrics to enable on the stream."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for metric in var.shard_level_metrics : can(index(["IncomingBytes", "OutgoingBytes", "IncomingRecords", "OutgoingRecords"], metric))])
    error_message = "The shard level metrics must be either 'IncomingBytes', 'OutgoingBytes', 'IncomingRecords', 'OutgoingRecords' or a combination of these"
  }
}

variable "kms_key_id" {
  description = "The ARN/ID of an AWS-managed or customer master key (CMK) for Amazon Kinesis Data Streams."
  type        = string
  default     = "alias/aws/kinesis"
}

variable "kinesis_data_stream_resource_policy" {
  description = "The JSON resource policy to attach to the stream to manage cross-account access to data streams."
  type        = string
  default     = null
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


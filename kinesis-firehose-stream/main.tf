# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream
resource "aws_kinesis_firehose_delivery_stream" "this" {
  name = var.name

  # kinesis source configuration
  kinesis_source_configuration {
    role_arn           = var.role_arn
    kinesis_stream_arn = var.kinesis_data_stream_arn
  }

  destination = var.destination

  # s3 destination configuration
  dynamic "extended_s3_configuration" {
    for_each = var.destination == "extended_s3" ? [1] : []
    content {
      bucket_arn = var.s3_destination_configuration.bucket_arn
      role_arn   = var.role_arn

      buffering_interval = var.s3_destination_configuration.buffering_interval
      buffering_size     = var.s3_destination_configuration.buffering_size

      compression_format  = var.s3_destination_configuration.compression_format
      prefix              = var.s3_destination_configuration.prefix
      kms_key_arn         = var.s3_destination_configuration.kms_key_arn
      error_output_prefix = var.s3_destination_configuration.error_output_prefix

      custom_time_zone = var.s3_destination_configuration.custom_time_zone

      s3_backup_mode = var.s3_destination_configuration.s3_backup_mode


      dynamic "s3_backup_configuration" {
        for_each = var.s3_destination_configuration.s3_backup_mode == "Enabled" ? [1] : []
        content {
          role_arn            = var.role_arn
          bucket_arn          = var.backup_s3_configuration.bucket_arn
          buffering_interval  = var.backup_s3_configuration.buffering_interval
          buffering_size      = var.backup_s3_configuration.buffering_size
          compression_format  = var.backup_s3_configuration.compression_format
          prefix              = var.backup_s3_configuration.prefix
          error_output_prefix = var.backup_s3_configuration.error_output_prefix
          kms_key_arn         = var.backup_s3_configuration.kms_key_arn
        }
      }

      cloudwatch_logging_options {
        enabled         = var.cloudwatch_logging_options.enabled
        log_group_name  = var.cloudwatch_logging_options.log_group_name
        log_stream_name = var.cloudwatch_logging_options.log_stream_name
      }

      processing_configuration {
        enabled = var.processing_configuration.enabled
        dynamic "processors" {
          for_each = var.processing_configuration.processors
          content {
            type = processors.value.type
            dynamic "parameters" {
              for_each = processors.value.parameters
              content {
                parameter_name  = parameters.value.parameter_name
                parameter_value = parameters.value.parameter_value
              }
            }
          }
        }
      }
    }
  }

  # splunk destination configuration
  dynamic "splunk_configuration" {
    for_each = var.destination == "splunk" ? [1] : []
    content {
      buffering_interval = var.splunk_destination_configuration.buffering_interval
      buffering_size     = var.splunk_destination_configuration.buffering_size

      hec_acknowledgment_timeout = var.splunk_destination_configuration.hec_acknowledgment_timeout
      hec_endpoint               = var.splunk_destination_configuration.hec_endpoint
      hec_endpoint_type          = var.splunk_destination_configuration.hec_endpoint_type
      retry_duration             = var.splunk_destination_configuration.retry_duration

      secrets_manager_configuration {
        enabled    = true
        secret_arn = var.splunk_destination_configuration.hec_token_secret_arn
        role_arn   = var.role_arn
      }

      s3_backup_mode = var.splunk_destination_configuration.s3_backup_mode

      s3_configuration {
        role_arn            = var.role_arn
        bucket_arn          = var.backup_s3_configuration.bucket_arn
        buffering_interval  = var.backup_s3_configuration.buffering_interval
        buffering_size      = var.backup_s3_configuration.buffering_size
        compression_format  = var.backup_s3_configuration.compression_format
        prefix              = var.backup_s3_configuration.prefix
        error_output_prefix = var.backup_s3_configuration.error_output_prefix
        kms_key_arn         = var.backup_s3_configuration.kms_key_arn
      }

      cloudwatch_logging_options {
        enabled         = var.cloudwatch_logging_options.enabled
        log_group_name  = var.cloudwatch_logging_options.log_group_name
        log_stream_name = var.cloudwatch_logging_options.log_stream_name
      }

      processing_configuration {
        enabled = var.processing_configuration.enabled
        dynamic "processors" {
          for_each = var.processing_configuration.processors
          content {
            type = processors.value.type
            dynamic "parameters" {
              for_each = processors.value.parameters
              content {
                parameter_name  = parameters.value.parameter_name
                parameter_value = parameters.value.parameter_value
              }
            }
          }
        }
      }
    }
  }

  tags = merge(var.tags, var.required_tags, var.additional_tags)
}
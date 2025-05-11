provider "aws" {
  region = "ap-south-1"
}

variables {
  name = "test-firehose"
  role_arn = "arn:aws:iam::123456789012:role/firehose_role"
  kinesis_data_stream_arn = "arn:aws:kinesis:ap-south-1:123456789012:stream/test-stream"
  destination = "extended_s3"
  s3_destination_configuration = {
    bucket_arn = "arn:aws:s3:::test-bucket"
    buffering_interval = 300
    buffering_size = 5
    compression_format = "GZIP"
    prefix = "test/"
    kms_key_arn = "arn:aws:kms:ap-south-1:123456789012:key/test-key"
    error_output_prefix = "error/"
    s3_backup_mode = "Enabled"
  }
  backup_s3_configuration = {
    bucket_arn = "arn:aws:s3:::backup-bucket"
    buffering_interval = 300
    buffering_size = 5
    compression_format = "GZIP"
    prefix = "backup/"
    error_output_prefix = "error/"
    kms_key_arn = "arn:aws:kms:ap-south-1:123456789012:key/test-key"
  }
  cloudwatch_logging_options = {
    enabled = true
    log_group_name = "test-log-group"
    log_stream_name = "test-log-stream"
  }

  processing_configuration = {
    enabled = true
    processors = [
      {
        type = "Lambda"
        parameters = [
          {
            parameter_name  = "LambdaArn"
            parameter_value = "arn:aws:lambda:ap-south-1:123456789012:function:test-function"
          }
        ]
      }
    ]
  }

  required_tags = {
    "environment" = "dev"
  }
  additional_tags = {
    "purpose" = "testing"
  }

  tags = {
    "Name" = "test-firehose"
  }
}


run "verify_firehose_stream_configuration" {
  command = plan
  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.name == var.name
    error_message = "Firehose stream name does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.destination == var.destination
    error_message = "Firehose stream destination does not match expected value"
  }
}

run "verify_firehose_s3_destination_configuration"{
  command = plan

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].bucket_arn == var.s3_destination_configuration.bucket_arn
    error_message = "Firehose S3 destination bucket ARN does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].buffering_interval == var.s3_destination_configuration.buffering_interval
    error_message = "Firehose S3 destination buffering interval does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].buffering_size == var.s3_destination_configuration.buffering_size
    error_message = "Firehose S3 destination buffering size does not match expected value"
  }
  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].compression_format == var.s3_destination_configuration.compression_format
    error_message = "Firehose S3 destination compression format does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].prefix == var.s3_destination_configuration.prefix
    error_message = "Firehose S3 destination prefix does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].kms_key_arn == var.s3_destination_configuration.kms_key_arn
    error_message = "Firehose S3 destination KMS key ARN does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].error_output_prefix == var.s3_destination_configuration.error_output_prefix
    error_message = "Firehose S3 destination error output prefix does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].custom_time_zone == var.s3_destination_configuration.custom_time_zone
    error_message = "Firehose S3 destination custom time zone does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].s3_backup_mode == var.s3_destination_configuration.s3_backup_mode
    error_message = "Firehose S3 destination backup mode does not match expected value"
  }


}

run "verify_firehost_destination_cloudwatch_logging_configuration" {
  command = plan
  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].cloudwatch_logging_options[0].enabled == var.cloudwatch_logging_options.enabled
    error_message = "Firehose S3 destination CloudWatch logging options enabled does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].cloudwatch_logging_options[0].log_group_name == var.cloudwatch_logging_options.log_group_name
    error_message = "Firehose S3 destination CloudWatch logging options log group name does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].cloudwatch_logging_options[0].log_stream_name == var.cloudwatch_logging_options.log_stream_name
    error_message = "Firehose S3 destination CloudWatch logging options log stream name does not match expected value"
  }  
}

run "verify_firehose_backup_s3_configuration" {
  command = plan
  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].s3_backup_configuration[0].bucket_arn == var.backup_s3_configuration.bucket_arn
    error_message = "Firehose backup S3 configuration bucket ARN does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].s3_backup_configuration[0].buffering_interval == var.backup_s3_configuration.buffering_interval
    error_message = "Firehose backup S3 configuration buffering interval does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].s3_backup_configuration[0].buffering_size == var.backup_s3_configuration.buffering_size
    error_message = "Firehose backup S3 configuration buffering size does not match expected value"
  }
  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].s3_backup_configuration[0].compression_format == var.backup_s3_configuration.compression_format
    error_message = "Firehose backup S3 configuration compression format does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].s3_backup_configuration[0].prefix == var.backup_s3_configuration.prefix
    error_message = "Firehose backup S3 configuration prefix does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].s3_backup_configuration[0].error_output_prefix == var.backup_s3_configuration.error_output_prefix
    error_message = "Firehose backup S3 configuration error output prefix does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].s3_backup_configuration[0].kms_key_arn == var.backup_s3_configuration.kms_key_arn
    error_message = "Firehose backup S3 configuration KMS key ARN does not match expected value"
  }
}

run "verify_firehose_processing_configuration" {
  command = plan
  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].processing_configuration[0].enabled == var.processing_configuration.enabled
    error_message = "Firehose processing configuration enabled does not match expected value"
  }

  assert {
    condition = length(aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[0].processing_configuration[0].processors) == length(var.processing_configuration.processors)
    error_message = "Firehose processing configuration processors length does not match expected value"
  }
}


run  "verify_firehose_splunk_destination" {
  command = plan 

  variables {
    destination = "splunk"
    splunk_destination_configuration = {
      hec_endpoint = "https://splunk.example.com:8088"
      hec_endpoint_type = "Raw"
      hec_acknowledgment_timeout = 600
      retry_duration_seconds = 300
      s3_backup_mode = "FailedEventsOnly"
      hec_token_secret_arn = "arn:aws:secretsmanager:us-west-2:123456789012:secret:splunk-token"
      buffering_interval = 60
      buffering_size = 5
    }
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.splunk_configuration[0].hec_endpoint == var.splunk_destination_configuration.hec_endpoint
    error_message = "Firehose Splunk configuration HEC endpoint does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.splunk_configuration[0].hec_endpoint_type == var.splunk_destination_configuration.hec_endpoint_type
    error_message = "Firehose Splunk configuration HEC endpoint type does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.splunk_configuration[0].hec_acknowledgment_timeout == var.splunk_destination_configuration.hec_acknowledgment_timeout
    error_message = "Firehose Splunk configuration HEC acknowledgment mode does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.splunk_configuration[0].retry_duration == var.splunk_destination_configuration.retry_duration
    error_message = "Firehose Splunk configuration retry duration does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.splunk_configuration[0].s3_backup_mode == var.splunk_destination_configuration.s3_backup_mode
    error_message = "Firehose Splunk configuration S3 backup mode does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.splunk_configuration[0].secrets_manager_configuration[0].secret_arn == var.splunk_destination_configuration.hec_token_secret_arn
    error_message = "Firehose Splunk configuration HEC token secret ARN does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.splunk_configuration[0].buffering_interval == var.splunk_destination_configuration.buffering_interval
    error_message = "Firehose Splunk configuration buffering interval does not match expected value"
  }

  assert {
    condition = aws_kinesis_firehose_delivery_stream.this.splunk_configuration[0].buffering_size == var.splunk_destination_configuration.buffering_size
    error_message = "Firehose Splunk configuration buffering size does not match expected value"
  }
}
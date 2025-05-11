<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.87.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.87.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kinesis_firehose_delivery_stream.this](https://registry.terraform.io/providers/hashicorp/aws/5.87.0/docs/resources/kinesis_firehose_delivery_stream) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_backup_s3_configuration"></a> [backup\_s3\_configuration](#input\_backup\_s3\_configuration) | (Optional) The S3 backup configuration for the Kinesis Firehose stream | <pre>object({<br/>    bucket_arn          = string<br/>    buffering_interval  = optional(number, 300)<br/>    buffering_size      = optional(number, 5)<br/>    compression_format  = optional(string, "UNCOMPRESSED")<br/>    prefix              = string<br/>    error_output_prefix = string<br/>    kms_key_arn         = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_cloudwatch_logging_options"></a> [cloudwatch\_logging\_options](#input\_cloudwatch\_logging\_options) | (Optional) The CloudWatch logging options for the Kinesis Firehose stream | <pre>object({<br/>    enabled         = optional(bool, false)<br/>    log_group_name  = optional(string, null)<br/>    log_stream_name = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_destination"></a> [destination](#input\_destination) | (Required) The destination for the Kinesis Firehose stream. Can be 'extended\_s3', 'splunk' | `string` | n/a | yes |
| <a name="input_kinesis_data_stream_arn"></a> [kinesis\_data\_stream\_arn](#input\_kinesis\_data\_stream\_arn) | (Required) The ARN of the Kinesis Data Stream to use as the source for the Kinesis Firehose stream | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) A name to identify the firehose stream | `string` | n/a | yes |
| <a name="input_processing_configuration"></a> [processing\_configuration](#input\_processing\_configuration) | (Optional) The processing configuration for the Kinesis Firehose stream | <pre>object({<br/>    enabled = optional(bool, false)<br/>    processors = optional(list(object({<br/>      type = string<br/>      parameters = list(object({<br/>        parameter_name  = string<br/>        parameter_value = string<br/>      }))<br/>    })), [])<br/>  })</pre> | `null` | no |
| <a name="input_required_tags"></a> [required\_tags](#input\_required\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | (Required) The ARN of the IAM role that Kinesis Firehose can assume to access the data stream, S3 bucket, or other destination | `string` | n/a | yes |
| <a name="input_s3_destination_configuration"></a> [s3\_destination\_configuration](#input\_s3\_destination\_configuration) | (Optional) The S3 destination configuration for the Kinesis Firehose stream | <pre>object({<br/>    bucket_arn          = string<br/>    buffering_interval  = optional(number, 300)<br/>    buffering_size      = optional(number, 5)<br/>    compression_format  = optional(string, "UNCOMPRESSED")<br/>    prefix              = string<br/>    error_output_prefix = string<br/>    kms_key_arn         = optional(string, null)<br/>    custom_time_zone    = optional(string, "UTC")<br/>    s3_backup_mode      = optional(string, "Disabled")<br/>  })</pre> | `null` | no |
| <a name="input_splunk_destination_configuration"></a> [splunk\_destination\_configuration](#input\_splunk\_destination\_configuration) | (Optional) The Splunk destination configuration for the Kinesis Firehose stream | <pre>object({<br/>    hec_endpoint               = string<br/>    hec_endpoint_type          = optional(string, "Raw")<br/>    hec_acknowledgment_timeout = optional(number, 600)<br/>    retry_duration             = optional(number, 300)<br/>    s3_backup_mode             = optional(string, "FailedEventsOnly")<br/>    hec_token_secret_arn       = string<br/>    buffering_interval         = optional(number, 60)<br/>    buffering_size             = optional(number, 5)<br/>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firehose_stream"></a> [firehose\_stream](#output\_firehose\_stream) | n/a |
| <a name="output_firehose_stream_arn"></a> [firehose\_stream\_arn](#output\_firehose\_stream\_arn) | n/a |
<!-- END_TF_DOCS -->
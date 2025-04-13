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
| [aws_kinesis_stream.this](https://registry.terraform.io/providers/hashicorp/aws/5.87.0/docs/resources/kinesis_stream) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_capacity_mode"></a> [capacity\_mode](#input\_capacity\_mode) | (Optional) The capacity mode of the stream. Can be either 'PROVISIONED' or 'ON\_DEMAND'. | `string` | `"ON_DEMAND"` | no |
| <a name="input_encryption_type"></a> [encryption\_type](#input\_encryption\_type) | The name of the kinesis data stream to create | `string` | `"KMS"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN/ID of an AWS-managed or customer master key (CMK) for Amazon Kinesis Data Streams. | `string` | `"alias/aws/kinesis"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) A name to identify the stream | `string` | n/a | yes |
| <a name="input_required_tags"></a> [required\_tags](#input\_required\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_retention_period"></a> [retention\_period](#input\_retention\_period) | (Optional) Length of time data records are accessible after they are added to the stream. The maximum value of a stream's retention period is 8760 hours. Minimum value is 24. | `number` | `24` | no |
| <a name="input_shard_count"></a> [shard\_count](#input\_shard\_count) | (Optional) The number of shards that the stream will use | `number` | `1` | no |
| <a name="input_shard_level_metrics"></a> [shard\_level\_metrics](#input\_shard\_level\_metrics) | (Optional) The shard level metrics to enable on the stream. | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
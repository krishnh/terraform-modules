# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream
resource "aws_kinesis_stream" "this" {
  name             = var.name
  shard_count      = var.shard_count
  retention_period = var.retention_period

  shard_level_metrics = var.shard_level_metrics

  stream_mode_details {
    stream_mode = var.capacity_mode
  }

  encryption_type = var.encryption_type

  kms_key_id = var.kms_key_id

  tags = merge(var.tags, var.required_tags, var.additional_tags)
}
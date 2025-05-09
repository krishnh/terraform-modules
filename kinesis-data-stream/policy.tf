resource "aws_kinesis_resource_policy" "this" {
  count        = var.kinesis_data_stream_resource_policy == null ? 0 : 1
  resource_arn = aws_kinesis_stream.this.arn
  policy       = var.kinesis_data_stream_resource_policy
}
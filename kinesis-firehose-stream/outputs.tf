output "firehose_stream_arn" {
  value = aws_kinesis_firehose_delivery_stream.this.arn
}

output "firehose_stream" {
  value = aws_kinesis_firehose_delivery_stream.this
}
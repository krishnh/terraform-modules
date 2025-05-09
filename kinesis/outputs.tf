output "stream_arn" {
  description = "The ARN of the Kinesis stream"
  value       = aws_kinesis_stream.this.arn
}

output "stream_id" {
  description = "The ID of the Kinesis stream"
  value       = aws_kinesis_stream.this.id
}

output "stream" {
  description = "The Kinesis stream"
  value       = aws_kinesis_stream.this
}
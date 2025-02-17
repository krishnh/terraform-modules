locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  topic_arn = aws_sns_topic.this.arn
}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription
resource "aws_sns_topic_subscription" "this" {
  for_each  = { for subscription in var.subscriptions : subscription.endpoint => subscription }
  endpoint  = each.value.endpoint
  protocol  = each.value.protocol
  topic_arn = local.topic_arn
}

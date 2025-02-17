data "aws_iam_policy_document" "this" {

  source_policy_documents = [
    templatefile("${path.module}/policy/base-topic-access-policy.json", {
      topic_arn  = local.topic_arn
      account_id = local.account_id
    })
  ]

  dynamic "statement" {
    for_each = var.access_policy_statements
    content {
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = [local.topic_arn]
      dynamic "principals" {
        for_each = statement.value.principals
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
      dynamic "condition" {
        for_each = statement.value.conditions
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_sns_topic_policy" "this" {
  arn    = aws_sns_topic.this.arn
  policy = data.aws_iam_policy_document.this.json
}
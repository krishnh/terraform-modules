# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "this" {
  source_policy_documents = [
    templatefile("${path.module}/policy/base-queue-access-policy.json", {
      queue_arn  = local.queue_arn
      account_id = local.account_id
    })
  ]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy
resource "aws_sqs_queue_policy" "this" {
  queue_url = aws_sqs_queue.this.id
  policy    = data.aws_iam_policy_document.this.json
}
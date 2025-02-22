# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic
resource "aws_sns_topic" "this" {
  name              = var.name
  display_name      = var.display_name
  kms_master_key_id = var.kms_master_key_id
  tags              = merge(var.required_tags, var.additional_tags)
}

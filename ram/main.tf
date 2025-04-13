# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share
resource "aws_ram_resource_share" "this" {
  name = var.name
  tags = merge(var.required_tags, var.additional_tags)
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association
resource "aws_ram_resource_association" "this" {
  for_each           = toset(var.resource_arns)
  resource_arn       = each.key
  resource_share_arn = aws_ram_resource_share.this.arn
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association
resource "aws_ram_principal_association" "this" {
  for_each           = toset(var.principal_arns)
  principal          = each.key
  resource_share_arn = aws_ram_resource_share.this.arn
}

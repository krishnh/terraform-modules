# ram

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.87.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.87.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ram_principal_association.this](https://registry.terraform.io/providers/hashicorp/aws/5.87.0/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.this](https://registry.terraform.io/providers/hashicorp/aws/5.87.0/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.this](https://registry.terraform.io/providers/hashicorp/aws/5.87.0/docs/resources/ram_resource_share) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the resource share to create | `string` | n/a | yes |
| <a name="input_principal_arns"></a> [principal\_arns](#input\_principal\_arns) | List of principal arns to whom to share the resources to. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN. | `list(string)` | `[]` | no |
| <a name="input_required_tags"></a> [required\_tags](#input\_required\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_resource_arns"></a> [resource\_arns](#input\_resource\_arns) | List of resource arns to be shared | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_share"></a> [resource\_share](#output\_resource\_share) | n/a |
| <a name="output_resource_share_arn"></a> [resource\_share\_arn](#output\_resource\_share\_arn) | n/a |
<!-- END_TF_DOCS -->

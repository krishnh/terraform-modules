provider "aws" {
  region = "us-west-2"
}

variables {
  name          = "test-resource-share"
  resource_arns = ["arn:aws:ec2:us-west-2:111122223333:transit-gateway/tgw-0fb8421e2da853bf3"]
  principals    = ["111122223324"]
  required_tags = {
    "bank:environment" = "dev"
  }
  additional_tags = {
    "purpose" = "testing"
  }
}

run "create_resource_share" {}


run "verify_resource_share_properties" {
  command = plan

  assert {
    condition     = aws_ram_resource_share.this.name == var.name
    error_message = "name is not passed correctly"
  }
  assert {
    condition     = aws_sqs_queue.this.tags["bank:environment"] == var.required_tags["bank:environment"]
    error_message = "Required Tag 'bank:environment' is not set correctly"
  }
  assert {
    condition     = aws_sqs_queue.this.tags["purpose"] == var.additional_tags["purpose"]
    error_message = "Additional Tag 'purpose' is not set correctly"
  }
}


run "verify_ram_resource_association_properties" {
  command = plan
  assert {
    condition     = length(aws_ram_resource_association.this) == length(var.resource_arns)
    error_message = "Number of resources passed to resource association do not match with provided input"
  }
  assert {
    condition     = [for resource_arn, _ in aws_ram_resource_association.this : resource_arn] == var.resource_arns
    error_message = "Resource arns passed to resource association do not match with provided resource arns"
  }
}

run "verify_ram_principal_association_properties" {
  command = plan
  assert {
    condition     = length(aws_ram_principal_association.this) == length(var.principal_arns)
    error_message = "Number of principal passed to principal association do not match with provided input"
  }
  assert {
    condition     = [for principal_arn, _ in aws_ram_principal_association.this : principal_arn] == var.principal_arns
    error_message = "Principal arns passed to principal association do not match with provided principal arns"
  }
}


# Negative test case
run "fail_for_empty_name" {
  command = plan
  variables {
    name = null
  }
  expect_failures = [
    var.name
  ]
}

run "fail_for_long_name" {
  command = plan
  variables {
    name = join("", [for i in range(0, 120) : "a"])
  }
  expect_failures = [
    var.name
  ]
}

run "fail_for_empty_resource_arns" {
  command = plan
  variables {
    resource_arns = null
  }
  expect_failures = [
    var.resource_arns
  ]
}


run "fail_for_empty_principal_arns" {
  command = plan
  variables {
    principal_arns = []
  }
  expect_failures = [
    var.principal_arns
  ]
}
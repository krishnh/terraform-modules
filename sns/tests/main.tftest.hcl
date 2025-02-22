provider "aws" {
  region = "us-west-2"
}

variables {
  name              = "test-topic"
  display_name      = "Test Topic"
  kms_master_key_id = "alias/aws/sns"
  access_policy_statements = [
    {
      sid       = "AllowSubscribeFromSQS"
      effect    = "Allow"
      actions   = ["sns:Subscribe"]
      resources = ["arn:aws:sns:us-west-2:123456789012:test-topic"]
      principals = [
        {
          type        = "Service"
          identifiers = ["sqs.amazonaws.com"]
        }
      ]
      conditions = [
        {
          test     = "StringEquals"
          variable = "AWS:SourceOwner"
          values   = ["123456789012"]
        }
      ]
    }
  ]
  subscriptions = [
    {
      protocol = "sqs"
      endpoint = "arn:aws:sqs:us-west-2:123456789012:test-queue"
    }
  ]
  required_tags = {
    "mufg:environment" = "dev"
  }
  additional_tags = {
    "purpose" = "testing"
  }
}

# Positive test case
run "verify_topic_name" {
  command = plan
  assert {
    condition     = aws_sns_topic.this.name == "test-topic"
    error_message = "Topic name is not correct"
  }
  assert {
    condition     = aws_sns_topic.this.display_name == "Test Topic"
    error_message = "Topic display name is not correct"
  }
}

run "verify_topic_kms" {
  command = plan
  assert {
    condition     = aws_sns_topic.this.kms_master_key_id == "alias/aws/sns"
    error_message = "KMS master key id is not empty"
  }
}


run "verify_topic_tags" {
  command = plan
  assert {
    condition     = aws_sns_topic.this.tags["mufg:environment"] == var.required_tags["mufg:environment"]
    error_message = "Required Tag 'mufg:environment' is not set correctly"
  }
  assert {
    condition     = aws_sns_topic.this.tags["purpose"] == var.additional_tags["purpose"]
    error_message = "Additional Tag 'purpose' is not set correctly"
  }
}

run "verify_topic_empty_subscriptions" {
  command = plan
  variables {
    subscriptions = []
  }
  assert {
    condition     = length(aws_sns_topic_subscription.this) == 0
    error_message = "Subscription is not empty"
  }
}


run "verify_topic_subscriptions" {
  command = plan
  assert {
    condition     = aws_sns_topic_subscription.this["arn:aws:sqs:us-west-2:123456789012:test-queue"].protocol == "sqs"
    error_message = "Subscription protocol is not sqs"
  }

  assert {
    condition     = aws_sns_topic_subscription.this["arn:aws:sqs:us-west-2:123456789012:test-queue"].endpoint == "arn:aws:sqs:us-west-2:123456789012:test-queue"
    error_message = "Subscription endpoint is not correct"
  }
}


# Negative test case
run "verify_topic_name_invalid" {
  command = plan
  variables {
    name         = null
    display_name = join("", [for i in range(0, 120) : "a"])
  }
  expect_failures = [
    var.name,
    var.display_name
  ]
}

run "verify_topic_kms_invalid" {
  command = plan
  variables {
    kms_master_key_id = null
  }
  expect_failures = [
    var.kms_master_key_id
  ]
}

run "verify_topic_tag_reserved_prefix" {
  command = plan
  variables {
    additional_tags = {
      "aws:tag" = "test"
    }
  }
  expect_failures = [
    var.additional_tags
  ]
}


run "verify_topic_subscription_invalid_protocol" {
  command = plan
  variables {
    subscriptions = [
      {
        protocol = null
        endpoint = "abc"
      }
    ]
  }
  expect_failures = [
    var.subscriptions
  ]
}
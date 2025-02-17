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
  tags = {
    "environment" = "dev"
  }
}

# Positive test case
run "topic_name_check" {
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

run "topic_kms_enabled_check" {
  command = plan
  assert {
    condition     = aws_sns_topic.this.kms_master_key_id == "alias/aws/sns"
    error_message = "KMS master key id is not empty"
  }
}


run "topic_tag_check" {
  command = plan
  assert {
    condition     = aws_sns_topic.this.tags["environment"] == "dev"
    error_message = "Tag environment is not set to dev"
  }
}

run "topic_empty_subscription_check" {
  command = plan
  variables {
    subscriptions = []
  }
  assert {
    condition     = length(aws_sns_topic_subscription.this) == 0
    error_message = "Subscription is not empty"
  }
}


run "subscription_check" {
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
run "topic_name_null_check" {
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

run "topic_kms_null_check" {
  command = plan
  variables {
    kms_master_key_id = null
  }
  expect_failures = [
    var.kms_master_key_id
  ]
}

run "topic_tag_reserved_prefix_check" {
  command = plan
  variables {
    tags = {
      "aws:tag" = "test"
    }
  }
  expect_failures = [
    var.tags
  ]
}


run "topic_subscription_check" {
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
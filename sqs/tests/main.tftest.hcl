provider "aws" {
  region = "us-west-2"
}

variables {
  name              = "test-sqs"
  kms_master_key_id = "alias/aws/sqs"
  required_tags = {
    "mufg:environment" = "dev"
  }
  additional_tags = {
    "purpose" = "testing"
  }
}

# Positive test case
run "verify_queue_name" {
  command = plan
  assert {
    condition     = aws_sqs_queue.this.name == "test-sqs"
    error_message = "queue name is not correct"
  }
}

run "verify_queue_property_overrides" {
  command = plan
  variables {
    max_message_size          = 1024
    message_retention_seconds = 86400
    receive_wait_time_seconds = 15
    delay_seconds             = 10

  }
  assert {
    condition     = aws_sqs_queue.this.max_message_size == 1024
    error_message = "max_message_size is not correct"
  }
  assert {
    condition     = aws_sqs_queue.this.message_retention_seconds == 86400
    error_message = "message_retention_seconds is not correct"
  }
  assert {
    condition     = aws_sqs_queue.this.receive_wait_time_seconds == 15
    error_message = "receive_wait_time_seconds is not correct"
  }
  assert {
    condition     = aws_sqs_queue.this.delay_seconds == 10
    error_message = "delay_seconds is not correct"
  }
}

run "verify_queue_kms" {
  command = plan
  assert {
    condition     = aws_sqs_queue.this.kms_master_key_id == "alias/aws/sqs"
    error_message = "KMS master key id is not empty"
  }
}


run "verify_queue_tags" {
  command = plan
  assert {
    condition     = aws_sqs_queue.this.tags["mufg:environment"] == var.required_tags["mufg:environment"]
    error_message = "Required Tag 'mufg:environment' is not set correctly"
  }
  assert {
    condition     = aws_sqs_queue.this.tags["purpose"] == var.additional_tags["purpose"]
    error_message = "Additional Tag 'purpose' is not set correctly"
  }
}


# Negative test case
run "verify_queue_name_invalid" {
  command = plan
  variables {
    name = null
  }
  expect_failures = [
    var.name
  ]
}

run "verify_queue_property_overrides_invalid" {
  command = plan
  variables {
    max_message_size          = 1023
    message_retention_seconds = 0
    receive_wait_time_seconds = 21
    delay_seconds             = 901
  }
  expect_failures = [
    var.max_message_size,
    var.message_retention_seconds,
    var.receive_wait_time_seconds,
    var.delay_seconds
  ]
}

run "verify_queue_kms_invalid" {
  command = plan
  variables {
    kms_master_key_id = null
  }
  expect_failures = [
    var.kms_master_key_id
  ]
}

run "verify_queue_tag_reserved_prefix" {
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
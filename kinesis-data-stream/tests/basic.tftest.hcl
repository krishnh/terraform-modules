provider "aws" {
  region = "us-west-2"
}

variables {
  name                = "test-stream"
  shard_count         = 1
  retention_period    = 24
  encryption_type     = "KMS"
  shard_level_metrics = ["IncomingBytes", "OutgoingBytes"]
  kms_key_id          = "alias/aws/kinesis"

  required_tags = {
    "environment" = "dev"
  }
  additional_tags = {
    "purpose" = "testing"
  }
}

run "verify_kinesis_stream_properties" {
  command = plan

  assert {
    condition     = aws_kinesis_stream.this.name == var.name
    error_message = "name is not passed correctly"
  }
  assert {
    condition     = aws_kinesis_stream.this.shard_count == var.shard_count
    error_message = "shard_count is not passed correctly"
  }
  assert {
    condition     = aws_kinesis_stream.this.retention_period == var.retention_period
    error_message = "retention_period is not passed correctly"
  }
  assert {
    condition     = aws_kinesis_stream.this.encryption_type == var.encryption_type
    error_message = "encryption_type is not passed correctly"
  }

  assert {
    condition     = aws_kinesis_stream.this.shard_level_metrics == toset(var.shard_level_metrics)
    error_message = "shard_level_metrics is not passed correctly"
  }

  assert {
    condition     = aws_kinesis_stream.this.stream_mode_details[0].stream_mode == var.capacity_mode
    error_message = "capacity_mode is not passed correctly"
  }

  assert {
    condition     = aws_kinesis_stream.this.kms_key_id == var.kms_key_id
    error_message = "kms_key_id is not passed correctly"
  }
}

run "verify_kinesis_stream_tags" {
  command = plan

  assert {
    condition     = aws_kinesis_stream.this.tags["environment"] == var.required_tags["environment"]
    error_message = "Required Tag 'environment' is not set correctly"
  }
  assert {
    condition     = aws_kinesis_stream.this.tags["purpose"] == var.additional_tags["purpose"]
    error_message = "Additional Tag 'purpose' is not set correctly"
  }
}

run "verify_on_demand_capacity_mode" {
  command = plan
  variables {
    capacity_mode = "ON_DEMAND"
    shard_count   = null
  }
  assert {
    condition     = aws_kinesis_stream.this.stream_mode_details[0].stream_mode == "ON_DEMAND"
    error_message = "capacity_mode is not set to ON_DEMAND"
  }
}

run "verify_unencrypted_kinesis_stream" {
    command = plan 
    variables {
      encryption_type = "NONE"
      kms_key_id      = null
    }

    assert {
      condition     = aws_kinesis_stream.this.encryption_type == "NONE"
      error_message = "encryption_type is not set to NONE"
    }
    assert {
      condition     = aws_kinesis_stream.this.kms_key_id == null
      error_message = "kms_key_id is not set to null"
    }
}


run "fail_for_invalid_capacity_mode" {
  command = plan
  variables {
    capacity_mode = "INVALID"
  }
  expect_failures = [ var.capacity_mode ]
}

run "fail_for_invalid_shard_level_metrics" {
  command = plan
  variables {
    shard_level_metrics = ["INVALID"]
  }
  expect_failures = [ var.shard_level_metrics ]
}



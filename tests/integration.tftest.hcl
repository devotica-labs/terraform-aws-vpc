# Integration tests — apply + assert + destroy.
# Requires real AWS credentials. Triggered via workflow_dispatch on integration.yml.
# Run manually: terraform test -filter=tests/integration.tftest.hcl

provider "aws" {
  region = "ap-south-1"
}

variables {
  name                 = "integ-test-vpc"
  cidr_block           = "10.99.0.0/16"
  availability_zones   = ["ap-south-1a", "ap-south-1b"]
  public_subnet_cidrs  = ["10.99.0.0/24", "10.99.1.0/24"]
  private_subnet_cidrs = ["10.99.10.0/24", "10.99.11.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true   # cheaper for integration runs
  enable_flow_logs     = true
  tags                 = { Environment = "integration-test", Ephemeral = "true" }
}

run "apply_and_assert" {
  command = apply

  assert {
    condition     = aws_vpc.this.id != ""
    error_message = "VPC was not created."
  }
  assert {
    condition     = aws_vpc.this.cidr_block == "10.99.0.0/16"
    error_message = "VPC CIDR mismatch."
  }
  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "Expected 2 public subnets."
  }
  assert {
    condition     = length(aws_subnet.private) == 2
    error_message = "Expected 2 private subnets."
  }
  assert {
    condition     = length(aws_nat_gateway.this) == 1
    error_message = "Expected 1 NAT gateway (single mode)."
  }
  assert {
    condition     = aws_flow_log.this[0].id != ""
    error_message = "Flow log not created."
  }
  assert {
    condition     = length(aws_default_security_group.this[0].ingress) == 0
    error_message = "Default SG must have zero ingress rules."
  }
  assert {
    condition     = length(aws_default_security_group.this[0].egress) == 0
    error_message = "Default SG must have zero egress rules."
  }
}

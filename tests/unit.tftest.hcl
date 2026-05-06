# Plan-only unit tests — no AWS credentials required.

provider "aws" {
  region                      = "ap-south-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock"
  secret_key                  = "mock"
}

variables {
  name                 = "unit-test"
  cidr_block           = "10.0.0.0/16"
  availability_zones   = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_flow_logs     = true
  tags                 = { Environment = "unit-test" }
}

run "vpc_cidr_and_dns" {
  command = plan
  assert {
    condition     = aws_vpc.this.cidr_block == "10.0.0.0/16"
    error_message = "VPC CIDR must match input."
  }
  assert {
    condition     = aws_vpc.this.enable_dns_support == true
    error_message = "DNS support must be enabled by default."
  }
  assert {
    condition     = aws_vpc.this.enable_dns_hostnames == true
    error_message = "DNS hostnames must be enabled by default."
  }
}

run "subnet_counts" {
  command = plan
  assert {
    condition     = length(aws_subnet.public) == 3
    error_message = "Expected 3 public subnets."
  }
  assert {
    condition     = length(aws_subnet.private) == 3
    error_message = "Expected 3 private subnets."
  }
}

run "ha_nat_count" {
  command = plan
  assert {
    condition     = length(aws_nat_gateway.this) == 3
    error_message = "Expected 3 NAT gateways in HA mode."
  }
}

run "single_nat_count" {
  command = plan
  variables { single_nat_gateway = true }
  assert {
    condition     = length(aws_nat_gateway.this) == 1
    error_message = "Expected 1 NAT gateway in single mode."
  }
}

run "no_nat" {
  command = plan
  variables { enable_nat_gateway = false }
  assert {
    condition     = length(aws_nat_gateway.this) == 0
    error_message = "Expected 0 NAT gateways when disabled."
  }
}

run "flow_logs_enabled" {
  command = plan
  assert {
    condition     = length(aws_flow_log.this) == 1
    error_message = "Expected flow log when enabled."
  }
}

run "flow_logs_disabled" {
  command = plan
  variables { enable_flow_logs = false }
  assert {
    condition     = length(aws_flow_log.this) == 0
    error_message = "Expected no flow log when disabled."
  }
}

run "default_sg_managed" {
  command = plan
  assert {
    condition     = length(aws_default_security_group.this) == 1
    error_message = "Default SG must be managed by default."
  }
}

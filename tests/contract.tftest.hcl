# Contract tests — output surface is stable across minor + patch versions.
# Uses plan command — outputs are unknown at plan time so we check
# they are planned (not null) using length checks on known values.

provider "aws" {
  region                      = "ap-south-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock"
  secret_key                  = "mock"
}

variables {
  name                 = "contract-test"
  cidr_block           = "172.16.0.0/16"
  availability_zones   = ["ap-south-1a", "ap-south-1b"]
  public_subnet_cidrs  = ["172.16.0.0/24", "172.16.1.0/24"]
  private_subnet_cidrs = ["172.16.10.0/24", "172.16.11.0/24"]
  enable_nat_gateway   = true
  enable_flow_logs     = true
}

# Contract: VPC is planned with correct CIDR
run "vpc_cidr_matches_input" {
  command = plan
  assert {
    condition     = aws_vpc.this.cidr_block == "172.16.0.0/16"
    error_message = "VPC CIDR must reflect the input cidr_block."
  }
}

# Contract: correct number of public subnets planned
run "public_subnet_count_stable" {
  command = plan
  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "public_subnet_ids length must equal AZ count."
  }
}

# Contract: correct number of private subnets planned
run "private_subnet_count_stable" {
  command = plan
  assert {
    condition     = length(aws_subnet.private) == 2
    error_message = "private_subnet_ids length must equal AZ count."
  }
}

# Contract: NAT gateway count matches AZ count in HA mode
run "nat_gateway_count_ha" {
  command = plan
  assert {
    condition     = length(aws_nat_gateway.this) == 2
    error_message = "nat_gateway count must equal AZ count in HA mode."
  }
}

# Contract: flow log planned when enabled
run "flow_log_planned_when_enabled" {
  command = plan
  assert {
    condition     = length(aws_flow_log.this) == 1
    error_message = "flow_log must be planned when enable_flow_logs = true."
  }
}

# Contract: flow log absent when disabled
run "flow_log_absent_when_disabled" {
  command = plan
  variables { enable_flow_logs = false }
  assert {
    condition     = length(aws_flow_log.this) == 0
    error_message = "flow_log must not be planned when enable_flow_logs = false."
  }
}

# Contract: default SG managed when enabled
run "default_sg_managed" {
  command = plan
  assert {
    condition     = length(aws_default_security_group.this) == 1
    error_message = "default SG must be managed when manage_default_security_group = true."
  }
}

# Contract: database tier absent by default
run "database_tier_absent_by_default" {
  command = plan
  assert {
    condition     = length(aws_subnet.database) == 0
    error_message = "database subnets must not be planned when database_subnet_cidrs is empty."
  }
}

# Contract: database subnet count matches AZ count when enabled
run "database_subnet_count_stable" {
  command = plan
  variables {
    database_subnet_cidrs = ["172.16.20.0/24", "172.16.21.0/24"]
  }
  assert {
    condition     = length(aws_subnet.database) == 2
    error_message = "database_subnet_ids length must equal AZ count."
  }
}

# Contract: db subnet group created by default once database tier exists
run "db_subnet_group_default_on" {
  command = plan
  variables {
    database_subnet_cidrs = ["172.16.20.0/24", "172.16.21.0/24"]
  }
  assert {
    condition     = length(aws_db_subnet_group.this) == 1
    error_message = "db subnet group must be planned by default when database_subnet_cidrs is set."
  }
}

# Contract: interface endpoints absent by default
run "interface_endpoints_absent_by_default" {
  command = plan
  assert {
    condition     = length(aws_vpc_endpoint.interface) == 0
    error_message = "interface endpoints must not be planned when interface_endpoints is empty."
  }
}

# Contract: interface endpoint count matches requested service count
run "interface_endpoint_count_stable" {
  command = plan
  variables {
    interface_endpoints = ["ssm", "kms"]
  }
  assert {
    condition     = length(aws_vpc_endpoint.interface) == 2
    error_message = "interface endpoint count must equal the number of requested services."
  }
}


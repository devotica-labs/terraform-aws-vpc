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

run "no_database_tier_by_default" {
  command = plan
  assert {
    condition     = length(aws_subnet.database) == 0
    error_message = "Expected 0 database subnets when database_subnet_cidrs is empty."
  }
  assert {
    condition     = length(aws_db_subnet_group.this) == 0
    error_message = "Expected no db subnet group when database_subnet_cidrs is empty."
  }
}

run "database_tier_created" {
  command = plan
  variables {
    database_subnet_cidrs = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
  }
  assert {
    condition     = length(aws_subnet.database) == 3
    error_message = "Expected 3 database subnets, one per AZ."
  }
  assert {
    condition     = length(aws_route_table.database) == 3
    error_message = "Expected 3 database route tables, one per AZ."
  }
  assert {
    condition     = length(aws_db_subnet_group.this) == 1
    error_message = "Expected db subnet group to be created by default once database_subnet_cidrs is set."
  }
}

run "database_tier_route_table_associations" {
  command = plan
  variables {
    database_subnet_cidrs = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
  }
  assert {
    condition     = length(aws_route_table_association.database) == 3
    error_message = "Every database subnet must be associated with its own route table."
  }
}

run "elasticache_subnet_group_opt_in" {
  command = plan
  variables {
    database_subnet_cidrs           = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
    create_elasticache_subnet_group = true
  }
  assert {
    condition     = length(aws_elasticache_subnet_group.this) == 1
    error_message = "Expected elasticache subnet group when create_elasticache_subnet_group = true."
  }
}

run "no_interface_endpoints_by_default" {
  command = plan
  assert {
    condition     = length(aws_vpc_endpoint.interface) == 0
    error_message = "Expected 0 interface endpoints when interface_endpoints is empty."
  }
  assert {
    condition     = length(aws_security_group.interface_endpoints) == 0
    error_message = "Expected no endpoint security group when interface_endpoints is empty."
  }
}

run "interface_endpoints_created" {
  command = plan
  variables {
    interface_endpoints = ["ssm", "ecr.api", "kms"]
  }
  assert {
    condition     = length(aws_vpc_endpoint.interface) == 3
    error_message = "Expected 3 interface endpoints, one per requested service."
  }
  assert {
    condition     = length(aws_security_group.interface_endpoints) == 1
    error_message = "Expected exactly one shared security group for interface endpoints."
  }
}

run "interface_endpoints_use_private_tier_by_default" {
  command = plan
  variables {
    interface_endpoints = ["ssm"]
  }
  # subnet_ids is a set(string) containing unresolved subnet .id values at
  # plan time, so its length is itself unknown — can't assert on it here.
  # Base variables only populate private_subnet_cidrs (no database tier),
  # so a successful plan with the expected endpoint count is sufficient
  # proof the default ("private") tier path resolved correctly — if it had
  # incorrectly required the database tier, the precondition below would
  # have failed the plan instead.
  assert {
    condition     = length(aws_vpc_endpoint.interface) == 1
    error_message = "Expected exactly 1 interface endpoint planned using the default (private) tier."
  }
}

run "interface_endpoints_use_database_tier_when_selected" {
  command = plan
  variables {
    database_subnet_cidrs           = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
    interface_endpoints             = ["ssm"]
    interface_endpoints_subnet_tier = "database"
  }
  assert {
    condition     = length(aws_vpc_endpoint.interface) == 1
    error_message = "Expected exactly 1 interface endpoint planned using the database tier."
  }
}

run "interface_endpoints_database_tier_without_database_subnets_fails" {
  command = plan
  variables {
    interface_endpoints             = ["ssm"]
    interface_endpoints_subnet_tier = "database"
    # database_subnet_cidrs intentionally left at its default ([]) —
    # the lifecycle precondition on aws_vpc_endpoint.interface must catch
    # this misconfiguration at plan time, before any apply is attempted.
  }
  expect_failures = [
    aws_vpc_endpoint.interface["ssm"],
  ]
}


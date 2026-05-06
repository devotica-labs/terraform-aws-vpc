# Contract tests — output surface is stable across minor + patch versions.

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

run "vpc_id_present" {
  command = plan
  assert {
    condition     = output.vpc_id != null && output.vpc_id != ""
    error_message = "output.vpc_id must be non-empty."
  }
}

run "cidr_passthrough" {
  command = plan
  assert {
    condition     = output.vpc_cidr_block == "172.16.0.0/16"
    error_message = "output.vpc_cidr_block must reflect input."
  }
}

run "public_subnet_count" {
  command = plan
  assert {
    condition     = length(output.public_subnet_ids) == 2
    error_message = "public_subnet_ids length must equal AZ count."
  }
}

run "private_subnet_count" {
  command = plan
  assert {
    condition     = length(output.private_subnet_ids) == 2
    error_message = "private_subnet_ids length must equal AZ count."
  }
}

run "nat_ids_ha" {
  command = plan
  assert {
    condition     = length(output.nat_gateway_ids) == 2
    error_message = "nat_gateway_ids length must equal AZ count in HA mode."
  }
}

run "flow_log_id_present_when_enabled" {
  command = plan
  assert {
    condition     = output.flow_log_id != "" && output.flow_log_id != null
    error_message = "flow_log_id must be non-empty when enabled."
  }
}

run "flow_log_id_empty_when_disabled" {
  command = plan
  variables { enable_flow_logs = false }
  assert {
    condition     = output.flow_log_id == ""
    error_message = "flow_log_id must be empty string when disabled."
  }
}

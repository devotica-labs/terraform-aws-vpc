# ---------------------------------------------------------------------------
# Provider block — CI-friendly skip flags.
#
# The skip_* flags let `terraform plan` run in CI without calling STS
# GetCallerIdentity / EC2 IMDS. Credentials themselves come from
# placeholder AWS_* env vars set by the conftest job in
# terraform-shared-config — never real values.
#
# In a real deployment, drop the skip_* flags and rely on your normal
# credential chain (OIDC role, profile, assume-role, etc.).
# ---------------------------------------------------------------------------
provider "aws" {
  region                      = "ap-south-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

# Uses local path during development.
# Change to Registry source after first release:
#   source  = "devotica-labs/vpc/aws"
#   version = "~> 1.0"

module "vpc" {
  source = "../.."

  name = "sample-prod"

  cidr_block           = "10.0.0.0/16"
  availability_zones   = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false

  enable_dns_support   = true
  enable_dns_hostnames = true

  enable_ipv6 = true

  enable_flow_logs         = true
  flow_logs_retention_days = 90
  flow_logs_traffic_type   = "ALL"

  manage_default_security_group = true

  tags = {
    Environment = "production"
    Project     = "sample"
    CostCenter  = "platform"
    Owner       = "cloud-team@example.com"
  }
}

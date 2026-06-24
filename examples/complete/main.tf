# ---------------------------------------------------------------------------
# Provider block — CI-friendly skip flags + non-AWS-shaped placeholder creds.
#
# The skip_* flags let `terraform plan` run without calling STS
# GetCallerIdentity / EC2 IMDS. The access_key / secret_key values are
# intentionally NOT AWS-shaped (no AKIA / ASIA prefix, no 40-char base64)
# so gitleaks does not flag them as a leaked AWS access key — they exist
# only to satisfy the provider credential chain.
#
# In a real deployment, drop the skip_* flags AND the placeholder creds,
# and rely on your normal credential chain (OIDC role, profile,
# assume-role, etc.).
# ---------------------------------------------------------------------------
provider "aws" {
  region                      = "ap-south-1"
  access_key                  = "not-a-real-aws-key"
  secret_key                  = "not-a-real-aws-secret"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

# NOTE: temporarily pinned to local source while the database subnet tier
# and interface VPC endpoint features are under development. Once a new
# version is tagged and published, switch this back to:
#   source  = "devotica-labs/vpc/aws"
#   version = "~> 0.7"   (or whatever the new minor version is)

module "vpc" {
  source = "../.."

  name = "sample-prod"

  cidr_block            = "10.0.0.0/16"
  availability_zones    = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  public_subnet_cidrs   = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs  = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  database_subnet_cidrs = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false

  enable_dns_support   = true
  enable_dns_hostnames = true

  enable_ipv6 = true

  enable_flow_logs         = true
  flow_logs_retention_days = 90
  flow_logs_traffic_type   = "ALL"

  manage_default_security_group = true

  # Database tier — isolated subnets for RDS, ElastiCache, Redshift.
  create_database_subnet_group    = true
  create_elasticache_subnet_group = true

  # Interface VPC Endpoints — PrivateLink access to AWS APIs from private
  # subnets without a NAT gateway in the path.
  interface_endpoints             = ["ecr.api", "ecr.dkr", "ssm", "ssmmessages", "ec2messages", "kms", "secretsmanager", "logs", "sts"]
  interface_endpoints_private_dns = true
  interface_endpoints_subnet_tier = "private"

  # Foundation Plan §15.2 — six mandatory tags on every resource.
  tags = {
    Environment = "production"
    Project     = "sample"
    Owner       = "cloud-team@example.com"
    CostCenter  = "platform"
    ManagedBy   = "Terraform"
    Repo        = "https://github.com/devotica-labs/terraform-aws-vpc"
  }
}


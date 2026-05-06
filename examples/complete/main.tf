module "vpc" {
  source  = "devotica-labs/vpc/aws"
  version = "~> 1.0"

  name = "sample-prod"

  cidr_block           = "10.0.0.0/16"
  availability_zones   = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]

  # HA NAT — one per AZ
  enable_nat_gateway = true
  single_nat_gateway = false

  # DNS
  enable_dns_support   = true
  enable_dns_hostnames = true

  # IPv6
  enable_ipv6 = true

  # Flow logs
  enable_flow_logs         = true
  flow_logs_retention_days = 90
  flow_logs_traffic_type   = "ALL"

  # CIS hardening
  manage_default_security_group = true

  tags = {
    Environment = "production"
    Project     = "sample"
    CostCenter  = "platform"
    Owner       = "cloud-team@example.com"
  }
}

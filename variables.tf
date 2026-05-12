# ---------------------------------------------------------------------------
# Core identity
# ---------------------------------------------------------------------------

variable "name" {
  description = "Logical name for the VPC. Used as a prefix for all child resources."
  type        = string
  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 50
    error_message = "name must be 1–50 characters."
  }
}

# ---------------------------------------------------------------------------
# Networking
# ---------------------------------------------------------------------------

variable "cidr_block" {
  description = "Primary IPv4 CIDR block for the VPC (e.g. 10.0.0.0/16)."
  type        = string
  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "cidr_block must be valid CIDR notation."
  }
}

variable "availability_zones" {
  description = "Ordered list of AZ names to span (e.g. [\"ap-south-1a\", \"ap-south-1b\"]). Must have 2–6 entries."
  type        = list(string)
  validation {
    condition     = length(var.availability_zones) >= 2 && length(var.availability_zones) <= 6
    error_message = "Provide between 2 and 6 Availability Zones."
  }
}

variable "public_subnet_cidrs" {
  description = "IPv4 CIDRs for public subnets. Length must match availability_zones. Leave empty to create no public subnets."
  type        = list(string)
  default     = []
  validation {
    condition     = alltrue([for c in var.public_subnet_cidrs : can(cidrhost(c, 0))])
    error_message = "All public_subnet_cidrs must be valid CIDR notation."
  }
}

variable "private_subnet_cidrs" {
  description = "IPv4 CIDRs for private subnets. Length must match availability_zones. Leave empty to create no private subnets."
  type        = list(string)
  default     = []
  validation {
    condition     = alltrue([for c in var.private_subnet_cidrs : can(cidrhost(c, 0))])
    error_message = "All private_subnet_cidrs must be valid CIDR notation."
  }
}

# ---------------------------------------------------------------------------
# NAT Gateway
# ---------------------------------------------------------------------------

variable "enable_nat_gateway" {
  description = "Create NAT gateways to give private subnets outbound Internet access."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Route all private subnets through one NAT gateway (first AZ). Reduces cost; not HA. Use only in dev/sandbox."
  type        = bool
  default     = false
}

# ---------------------------------------------------------------------------
# DNS
# ---------------------------------------------------------------------------

variable "enable_dns_support" {
  description = "Enable DNS resolution in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Assign public DNS hostnames to instances with public IPs."
  type        = bool
  default     = true
}

# ---------------------------------------------------------------------------
# IPv6
# ---------------------------------------------------------------------------

variable "enable_ipv6" {
  description = "Request an Amazon-provided /56 IPv6 CIDR and assign /64 CIDRs to every subnet."
  type        = bool
  default     = false
}

# ---------------------------------------------------------------------------
# VPC Flow Logs
# ---------------------------------------------------------------------------

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs to CloudWatch Logs."
  type        = bool
  default     = true
}

variable "flow_logs_retention_days" {
  description = "CloudWatch Logs retention period for flow log entries. Ignored when flow_logs_destination_type = 's3'."
  type        = number
  default     = 30
  validation {
    condition = contains(
      [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653],
      var.flow_logs_retention_days
    )
    error_message = "flow_logs_retention_days must be an AWS-supported value."
  }
}

variable "flow_logs_traffic_type" {
  description = "Traffic to capture: ACCEPT, REJECT, or ALL."
  type        = string
  default     = "ALL"
  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.flow_logs_traffic_type)
    error_message = "flow_logs_traffic_type must be ACCEPT, REJECT, or ALL."
  }
}

variable "flow_logs_destination_type" {
  description = "Where to ship VPC Flow Logs. 'cloud-watch-logs' (default) bills by ingestion + storage and integrates with CloudWatch Insights. 's3' is much cheaper for long retention (months/years) and is AWS's recommended destination for compliance / audit workloads."
  type        = string
  default     = "cloud-watch-logs"
  validation {
    condition     = contains(["cloud-watch-logs", "s3"], var.flow_logs_destination_type)
    error_message = "flow_logs_destination_type must be 'cloud-watch-logs' or 's3'."
  }
}

variable "flow_logs_s3_bucket_arn" {
  description = "ARN of the S3 bucket (optionally with /prefix) to receive flow logs. Required when flow_logs_destination_type = 's3'; ignored otherwise. The bucket must already exist and have an S3 bucket policy allowing the VPC Flow Logs service."
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------
# CIS hardening
# ---------------------------------------------------------------------------

variable "manage_default_security_group" {
  description = "Take ownership of the default security group and remove all rules (CIS AWS Foundations 4.3)."
  type        = bool
  default     = true
}

# ---------------------------------------------------------------------------
# VPC Endpoints — Gateway type (free; S3 + DynamoDB).
#
# Interface endpoints (SSM, ECR, KMS, etc.) cost ~$7/month per endpoint per AZ
# and are out of scope for this module — use a dedicated terraform-aws-vpc-
# endpoints module when you need them.
# ---------------------------------------------------------------------------

variable "enable_s3_gateway_endpoint" {
  description = "Create a free S3 gateway VPC endpoint attached to every private route table. Removes NAT charges for S3 traffic from private subnets."
  type        = bool
  default     = false
}

variable "enable_dynamodb_gateway_endpoint" {
  description = "Create a free DynamoDB gateway VPC endpoint attached to every private route table. Removes NAT charges for DynamoDB traffic from private subnets."
  type        = bool
  default     = false
}

# ---------------------------------------------------------------------------
# Custom routes — beyond the built-in 0.0.0.0/0 → IGW (public) and
# 0.0.0.0/0 → NAT (private). Use for Transit Gateway, VPC peering, VPN,
# or IPv6 default routes.
#
# Each entry must specify exactly one destination_* and exactly one target.
# Terraform will reject ambiguous combinations at apply time.
# ---------------------------------------------------------------------------

variable "additional_public_routes" {
  description = "Custom routes added to the shared public route table beyond 0.0.0.0/0 → IGW. Each entry: one destination + one target."
  type = list(object({
    destination_cidr_block      = optional(string)
    destination_ipv6_cidr_block = optional(string)
    transit_gateway_id          = optional(string)
    vpc_peering_connection_id   = optional(string)
    gateway_id                  = optional(string)
    nat_gateway_id              = optional(string)
    network_interface_id        = optional(string)
    vpc_endpoint_id             = optional(string)
  }))
  default = []
}

variable "additional_private_routes" {
  description = "Custom routes added to EVERY private route table (one per AZ). Each entry: one destination + one target. Same field shape as additional_public_routes."
  type = list(object({
    destination_cidr_block      = optional(string)
    destination_ipv6_cidr_block = optional(string)
    transit_gateway_id          = optional(string)
    vpc_peering_connection_id   = optional(string)
    gateway_id                  = optional(string)
    nat_gateway_id              = optional(string)
    network_interface_id        = optional(string)
    vpc_endpoint_id             = optional(string)
  }))
  default = []
}

# ---------------------------------------------------------------------------
# Tagging
# ---------------------------------------------------------------------------

variable "tags" {
  description = "Additional tags merged onto every taggable resource."
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Tags applied ONLY to public subnets, in addition to var.tags. Common use: EKS ELB discovery — set {\"kubernetes.io/role/elb\" = \"1\"}."
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Tags applied ONLY to private subnets, in addition to var.tags. Common use: EKS internal-ELB discovery — set {\"kubernetes.io/role/internal-elb\" = \"1\"}."
  type        = map(string)
  default     = {}
}

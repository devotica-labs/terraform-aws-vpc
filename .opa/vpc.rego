# vpc.rego — basic OPA policies for terraform-aws-vpc
# These will be replaced by the full terraform-policies repo when ready.
# See: github.com/devotica-labs/terraform-policies

package main

# ---------------------------------------------------------------------------
# Deny public S3 buckets (state bucket must never be public)
# ---------------------------------------------------------------------------
deny[msg] {
  r := input.resource_changes[_]
  r.type == "aws_s3_bucket_public_access_block"
  r.change.after.block_public_acls == false
  msg := sprintf("S3 bucket %v must block public ACLs", [r.address])
}

# ---------------------------------------------------------------------------
# Deny flow logs being disabled
# ---------------------------------------------------------------------------
warn[msg] {
  r := input.resource_changes[_]
  r.type == "aws_vpc"
  not any_flow_log_for_vpc
  msg := "VPC should have flow logs enabled"
}

any_flow_log_for_vpc {
  r := input.resource_changes[_]
  r.type == "aws_flow_log"
  r.change.after != null
}

# ---------------------------------------------------------------------------
# Deny resources without mandatory tags
# ---------------------------------------------------------------------------
required_tags := {"ManagedBy", "Module"}

deny[msg] {
  r := input.resource_changes[_]
  r.change.after != null
  tags := r.change.after.tags
  required_tag := required_tags[_]
  not tags[required_tag]
  msg := sprintf(
    "Resource %v is missing required tag: %v",
    [r.address, required_tag]
  )
}


# terraform-aws-vpc

Production-grade AWS VPC module — public/private subnets, HA NAT gateways,
VPC Flow Logs, CIS-hardened default security group.

Part of the [Devotica Terraform module catalog](https://registry.terraform.io/modules/devotica-labs).

[![CI](https://github.com/devotica-labs/terraform-aws-vpc/actions/workflows/ci.yml/badge.svg)](https://github.com/devotica-labs/terraform-aws-vpc/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

## Usage

### Basic

```hcl
module "vpc" {
  source = "../.."

  name               = "my-vpc"
  cidr_block         = "10.0.0.0/16"
  availability_zones = ["ap-south-1a", "ap-south-1b"]

  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
}
```

<!-- BEGIN_TF_DOCS -->


## Usage

### Basic

```hcl
# Uses local path during development.
# Change to Registry source after first release:
#   source  = "devotica-labs/vpc/aws"
#   version = "~> 0.3"

module "vpc" {
  source = "../.."

  name               = "my-vpc"
  cidr_block         = "10.0.0.0/16"
  availability_zones = ["ap-south-1a", "ap-south-1b"]

  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
}
```

### Complete

```hcl
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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.30 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.30 |
## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_default_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private_nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Ordered list of AZ names to span (e.g. ["ap-south-1a", "ap-south-1b"]). Must have 2–6 entries. | `list(string)` | n/a | yes |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | Primary IPv4 CIDR block for the VPC (e.g. 10.0.0.0/16). | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Logical name for the VPC. Used as a prefix for all child resources. | `string` | n/a | yes |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Assign public DNS hostnames to instances with public IPs. | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable DNS resolution in the VPC. | `bool` | `true` | no |
| <a name="input_enable_flow_logs"></a> [enable\_flow\_logs](#input\_enable\_flow\_logs) | Enable VPC Flow Logs to CloudWatch Logs. | `bool` | `true` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Request an Amazon-provided /56 IPv6 CIDR and assign /64 CIDRs to every subnet. | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Create NAT gateways to give private subnets outbound Internet access. | `bool` | `true` | no |
| <a name="input_flow_logs_retention_days"></a> [flow\_logs\_retention\_days](#input\_flow\_logs\_retention\_days) | CloudWatch Logs retention period for flow log entries. | `number` | `30` | no |
| <a name="input_flow_logs_traffic_type"></a> [flow\_logs\_traffic\_type](#input\_flow\_logs\_traffic\_type) | Traffic to capture: ACCEPT, REJECT, or ALL. | `string` | `"ALL"` | no |
| <a name="input_manage_default_security_group"></a> [manage\_default\_security\_group](#input\_manage\_default\_security\_group) | Take ownership of the default security group and remove all rules (CIS AWS Foundations 4.3). | `bool` | `true` | no |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | IPv4 CIDRs for private subnets. Length must match availability\_zones. Leave empty to create no private subnets. | `list(string)` | `[]` | no |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | IPv4 CIDRs for public subnets. Length must match availability\_zones. Leave empty to create no public subnets. | `list(string)` | `[]` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Route all private subnets through one NAT gateway (first AZ). Reduces cost; not HA. Use only in dev/sandbox. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags merged onto every taggable resource. | `map(string)` | `{}` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | ID of the default security group (locked down when manage\_default\_security\_group = true). |
| <a name="output_flow_log_cloudwatch_log_group_arn"></a> [flow\_log\_cloudwatch\_log\_group\_arn](#output\_flow\_log\_cloudwatch\_log\_group\_arn) | ARN of the CloudWatch Log Group for Flow Logs. Empty string when enable\_flow\_logs = false. |
| <a name="output_flow_log_id"></a> [flow\_log\_id](#output\_flow\_log\_id) | ID of the VPC Flow Log. Empty string when enable\_flow\_logs = false. |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | ID of the Internet Gateway. Empty string when no public subnets exist. |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | List of NAT Gateway IDs. Empty list when enable\_nat\_gateway = false. |
| <a name="output_nat_public_ips"></a> [nat\_public\_ips](#output\_nat\_public\_ips) | Elastic IP addresses associated with NAT gateways. |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | List of private route table IDs in AZ order. |
| <a name="output_private_subnet_arns"></a> [private\_subnet\_arns](#output\_private\_subnet\_arns) | List of private subnet ARNs. |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | List of private subnet IDs in the same order as availability\_zones. |
| <a name="output_public_route_table_id"></a> [public\_route\_table\_id](#output\_public\_route\_table\_id) | ID of the shared public route table. Empty string when no public subnets exist. |
| <a name="output_public_subnet_arns"></a> [public\_subnet\_arns](#output\_public\_subnet\_arns) | List of public subnet ARNs. |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | List of public subnet IDs in the same order as availability\_zones. |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | ARN of the VPC. |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | Primary IPv4 CIDR block of the VPC. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the VPC. |
| <a name="output_vpc_ipv6_cidr_block"></a> [vpc\_ipv6\_cidr\_block](#output\_vpc\_ipv6\_cidr\_block) | Amazon-provided IPv6 CIDR. Empty string when enable\_ipv6 = false. |
<!-- END_TF_DOCS -->

## Acknowledgements

This module is derived from
[SourceFuse arc-network](https://github.com/sourcefuse/terraform-aws-arc-network)
(Apache-2.0). arc-network provided the architectural blueprint for the
public/private/NAT layout, the variable shape, and the flow-log + VPC
endpoint patterns. Devotica's fork adapts the module for fintech defaults
required by Indian financial-services regulations (RBI, DPDP, SEBI),
enforces stricter mandatory tags, and integrates with our central
governance stack:

- CI: [`devotica-labs/terraform-shared-config`](https://github.com/devotica-labs/terraform-shared-config)
- Policy: [`devotica-labs/terraform-policies`](https://github.com/devotica-labs/terraform-policies)
- Bootstrap: [`devotica-labs/terraform-bootstrap-template`](https://github.com/devotica-labs/terraform-bootstrap-template)

See [NOTICE](NOTICE) for the full attribution.

## License
Apache-2.0 — see [LICENSE](LICENSE).

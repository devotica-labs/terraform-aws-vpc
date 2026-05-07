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
<!-- END_TF_DOCS -->

## License
Apache-2.0 — see [LICENSE](LICENSE).

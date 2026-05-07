# Uses local path during development.
# Change to Registry source after first release:
#   source  = "devotica-labs/vpc/aws"
#   version = "~> 1.0"

module "vpc" {
  source = "../.."

  name               = "my-vpc"
  cidr_block         = "10.0.0.0/16"
  availability_zones = ["ap-south-1a", "ap-south-1b"]

  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
}

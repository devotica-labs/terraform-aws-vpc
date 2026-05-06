locals {
  common_tags = merge(
    { ManagedBy = "terraform", Module = "terraform-aws-vpc" },
    var.tags
  )

  # Number of NAT gateways: 0 / 1 / one-per-AZ
  nat_gateway_count = (
    !var.enable_nat_gateway ? 0
    : var.single_nat_gateway ? 1
    : length(var.availability_zones)
  )

  # AZ keys for NAT gateways — stable under for_each
  nat_subnet_keys = [
    for i in range(local.nat_gateway_count) : var.availability_zones[i]
  ]

  # AZ → CIDR maps — stable keys survive AZ list reordering
  public_subnet_map = {
    for i, az in var.availability_zones :
    az => var.public_subnet_cidrs[i]
    if length(var.public_subnet_cidrs) > 0
  }

  private_subnet_map = {
    for i, az in var.availability_zones :
    az => var.private_subnet_cidrs[i]
    if length(var.private_subnet_cidrs) > 0
  }

  flow_log_group_name = "/aws/vpc/${var.name}"
}

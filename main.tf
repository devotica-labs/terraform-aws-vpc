# ---------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------

resource "aws_vpc" "this" {
  cidr_block                       = var.cidr_block
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = merge(local.common_tags, { Name = var.name })
}

# ---------------------------------------------------------------------------
# Default security group — CIS 4.3: no ingress or egress rules
# ---------------------------------------------------------------------------

resource "aws_default_security_group" "this" {
  count  = var.manage_default_security_group ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = "${var.name}-default-locked" })
}

# ---------------------------------------------------------------------------
# Internet Gateway
# ---------------------------------------------------------------------------

resource "aws_internet_gateway" "this" {
  count  = length(local.public_subnet_map) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = "${var.name}-igw" })
}

# ---------------------------------------------------------------------------
# Public subnets
# ---------------------------------------------------------------------------

resource "aws_subnet" "public" {
  for_each = local.public_subnet_map

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "${var.name}-public-${each.key}"
    Tier = "public"
  })
}

# ---------------------------------------------------------------------------
# Private subnets
# ---------------------------------------------------------------------------

resource "aws_subnet" "private" {
  for_each = local.private_subnet_map

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = merge(local.common_tags, {
    Name = "${var.name}-private-${each.key}"
    Tier = "private"
  })
}

# ---------------------------------------------------------------------------
# Elastic IPs for NAT gateways
# ---------------------------------------------------------------------------

resource "aws_eip" "nat" {
  for_each   = toset(local.nat_subnet_keys)
  domain     = "vpc"
  depends_on = [aws_internet_gateway.this]
  tags       = merge(local.common_tags, { Name = "${var.name}-nat-eip-${each.key}" })
}

# ---------------------------------------------------------------------------
# NAT Gateways
# ---------------------------------------------------------------------------

resource "aws_nat_gateway" "this" {
  for_each      = toset(local.nat_subnet_keys)
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  depends_on    = [aws_internet_gateway.this]
  tags          = merge(local.common_tags, { Name = "${var.name}-nat-${each.key}" })
}

# ---------------------------------------------------------------------------
# Public route table
# ---------------------------------------------------------------------------

resource "aws_route_table" "public" {
  count  = length(local.public_subnet_map) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route" "public_igw" {
  count                  = length(local.public_subnet_map) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table_association" "public" {
  for_each       = local.public_subnet_map
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[0].id
}

# ---------------------------------------------------------------------------
# Private route tables — one per AZ (HA) or shared (single-NAT)
# ---------------------------------------------------------------------------

resource "aws_route_table" "private" {
  for_each = local.private_subnet_map
  vpc_id   = aws_vpc.this.id
  tags     = merge(local.common_tags, { Name = "${var.name}-private-rt-${each.key}" })
}

resource "aws_route" "private_nat" {
  for_each = {
    for az, _ in local.private_subnet_map : az => az
    if var.enable_nat_gateway
  }

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = var.single_nat_gateway ? (
    aws_nat_gateway.this[var.availability_zones[0]].id
  ) : aws_nat_gateway.this[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each       = local.private_subnet_map
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

# ---------------------------------------------------------------------------
# VPC Flow Logs
# ---------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "flow_logs" {
  count             = var.enable_flow_logs ? 1 : 0
  name              = local.flow_log_group_name
  retention_in_days = var.flow_logs_retention_days
  tags              = merge(local.common_tags, { Name = local.flow_log_group_name })
}

resource "aws_iam_role" "flow_logs" {
  count              = var.enable_flow_logs ? 1 : 0
  name_prefix        = "${var.name}-vpc-flow-logs-"
  assume_role_policy = data.aws_iam_policy_document.flow_logs_assume[0].json
  tags               = local.common_tags
}

data "aws_iam_policy_document" "flow_logs_assume" {
  count = var.enable_flow_logs ? 1 : 0
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "flow_logs" {
  count       = var.enable_flow_logs ? 1 : 0
  name_prefix = "${var.name}-vpc-flow-logs-"
  role        = aws_iam_role.flow_logs[0].id
  policy      = data.aws_iam_policy_document.flow_logs_publish[0].json
}

data "aws_iam_policy_document" "flow_logs_publish" {
  count = var.enable_flow_logs ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup", "logs:CreateLogStream",
      "logs:PutLogEvents", "logs:DescribeLogGroups", "logs:DescribeLogStreams",
    ]
    resources = ["${aws_cloudwatch_log_group.flow_logs[0].arn}:*"]
  }
}

resource "aws_flow_log" "this" {
  count           = var.enable_flow_logs ? 1 : 0
  vpc_id          = aws_vpc.this.id
  traffic_type    = var.flow_logs_traffic_type
  iam_role_arn    = aws_iam_role.flow_logs[0].arn
  log_destination = aws_cloudwatch_log_group.flow_logs[0].arn
  tags            = merge(local.common_tags, { Name = "${var.name}-flow-log" })
}

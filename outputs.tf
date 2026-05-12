output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "ARN of the VPC."
  value       = aws_vpc.this.arn
}

output "vpc_cidr_block" {
  description = "Primary IPv4 CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "vpc_ipv6_cidr_block" {
  description = "Amazon-provided IPv6 CIDR. Empty string when enable_ipv6 = false."
  value       = var.enable_ipv6 ? aws_vpc.this.ipv6_cidr_block : ""
}

output "public_subnet_ids" {
  description = "List of public subnet IDs in the same order as availability_zones."
  value = [
    for az in var.availability_zones :
    aws_subnet.public[az].id
    if contains(keys(local.public_subnet_map), az)
  ]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs in the same order as availability_zones."
  value = [
    for az in var.availability_zones :
    aws_subnet.private[az].id
    if contains(keys(local.private_subnet_map), az)
  ]
}

output "public_subnet_arns" {
  description = "List of public subnet ARNs."
  value = [
    for az in var.availability_zones :
    aws_subnet.public[az].arn
    if contains(keys(local.public_subnet_map), az)
  ]
}

output "private_subnet_arns" {
  description = "List of private subnet ARNs."
  value = [
    for az in var.availability_zones :
    aws_subnet.private[az].arn
    if contains(keys(local.private_subnet_map), az)
  ]
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs. Empty list when enable_nat_gateway = false."
  value       = [for ngw in aws_nat_gateway.this : ngw.id]
}

output "nat_public_ips" {
  description = "Elastic IP addresses associated with NAT gateways."
  value       = [for eip in aws_eip.nat : eip.public_ip]
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway. Empty string when no public subnets exist."
  value       = length(aws_internet_gateway.this) > 0 ? aws_internet_gateway.this[0].id : ""
}

output "public_route_table_id" {
  description = "ID of the shared public route table. Empty string when no public subnets exist."
  value       = length(aws_route_table.public) > 0 ? aws_route_table.public[0].id : ""
}

output "private_route_table_ids" {
  description = "List of private route table IDs in AZ order."
  value = [
    for az in var.availability_zones :
    aws_route_table.private[az].id
    if contains(keys(local.private_subnet_map), az)
  ]
}

output "default_security_group_id" {
  description = "ID of the default security group (locked down when manage_default_security_group = true)."
  value = (
    length(aws_default_security_group.this) > 0
    ? aws_default_security_group.this[0].id
    : aws_vpc.this.default_security_group_id
  )
}

output "flow_log_id" {
  description = "ID of the VPC Flow Log. Empty string when enable_flow_logs = false."
  value       = length(aws_flow_log.this) > 0 ? aws_flow_log.this[0].id : ""
}

output "flow_log_cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch Log Group for Flow Logs. Empty string when enable_flow_logs = false."
  value       = length(aws_cloudwatch_log_group.flow_logs) > 0 ? aws_cloudwatch_log_group.flow_logs[0].arn : ""
}

output "s3_gateway_endpoint_id" {
  description = "ID of the S3 gateway VPC endpoint. Empty string when enable_s3_gateway_endpoint = false."
  value       = length(aws_vpc_endpoint.s3) > 0 ? aws_vpc_endpoint.s3[0].id : ""
}

output "dynamodb_gateway_endpoint_id" {
  description = "ID of the DynamoDB gateway VPC endpoint. Empty string when enable_dynamodb_gateway_endpoint = false."
  value       = length(aws_vpc_endpoint.dynamodb) > 0 ? aws_vpc_endpoint.dynamodb[0].id : ""
}

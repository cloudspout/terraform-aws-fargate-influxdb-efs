output "registry" {
  value = aws_service_discovery_service.influxdb
}

output "cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.influxdb
}

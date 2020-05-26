resource "aws_cloudwatch_log_group" "influxdb" {
  name              = "/aws/ecs/${var.name}/${terraform.workspace}/influxdb"
  retention_in_days = var.retention_in_days
}
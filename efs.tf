resource "aws_efs_file_system" "influxdb" {
  tags = merge(var.tags, {
    Name = "${var.name}-${terraform.workspace}-influxdb"
  })
}

resource "aws_efs_mount_target" "influxdb" {
  count = length(var.aws_subnets)

  file_system_id  = aws_efs_file_system.influxdb.id
  subnet_id       = var.aws_subnets[count.index].id
  security_groups = [aws_security_group.efs_influxdb_access.id]
}

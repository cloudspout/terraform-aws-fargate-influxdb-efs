resource "aws_efs_file_system" "influxdb" {
  count = var.use_efs ? 1 : 0

  tags = merge(var.tags, {
    Name = "${var.name}-${terraform.workspace}-influxdb"
  })
}

resource "aws_efs_mount_target" "influxdb" {
  count = var.use_efs ? length(var.aws_subnets) : 0

  file_system_id  = aws_efs_file_system.influxdb[0].id
  subnet_id       = var.aws_subnets[count.index].id
  security_groups = [aws_security_group.efs_influxdb_access.id]
}

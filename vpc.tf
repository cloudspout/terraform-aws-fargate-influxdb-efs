resource "aws_security_group" "efs_influxdb_access" {
  name        = "${var.name}-${terraform.workspace}-EFS-influxdb-access"
  description = "Allow access to the Influxdb EFS"
  vpc_id      = var.aws_vpc.id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    security_groups = [
      var.aws_security_group.id
    ]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-${terraform.workspace}-EFS-influxdb-access"
  })
}
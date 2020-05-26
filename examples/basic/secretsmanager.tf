resource "aws_secretsmanager_secret" "influxdb_admin-password" {
  name = "Example/${terraform.workspace}/influxdb/${local.admin_user}/password"

  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "influxdb_admin-password" {
  secret_id     = aws_secretsmanager_secret.influxdb_admin-password.id
  secret_string = random_password.influxdb_admin-password.result
}

resource "random_password" "influxdb_admin-password" {
  length           = 12
  special          = true
  override_special = "_%@"
}


resource "aws_secretsmanager_secret" "influxdb_rw_user-password" {
  name = "Example/${terraform.workspace}/influxdb/${local.rw_user}grafana-password"

  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "influxdb_rw_user-password" {
  secret_id     = aws_secretsmanager_secret.influxdb_rw_user-password.id
  secret_string = random_password.influxdb_rw_user-password.result
}

resource "random_password" "influxdb_rw_user-password" {
  length           = 12
  special          = true
  override_special = "_%@"
}


resource "aws_secretsmanager_secret" "influxdb_ro_user-password" {
  name = "Example/${terraform.workspace}/influxdb/${local.ro_user}/password"

  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "influxdb_ro_user-password" {
  secret_id     = aws_secretsmanager_secret.influxdb_ro_user-password.id
  secret_string = random_password.influxdb_ro_user-password.result
}

resource "random_password" "influxdb_ro_user-password" {
  length           = 12
  special          = true
  override_special = "_%@"
}

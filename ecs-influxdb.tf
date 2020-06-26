data "aws_region" "current" {}

data "template_file" "influxdb" {
  template = file("${path.module}/task-definitions/influxdb.tpl")

  vars = {
    cpu    = var.cpu
    memory = var.memory
    auth_enabled    = var.auth_enabled

    db_name            = var.name
    admin_username     = var.admin_user
    admin_password-arn = var.aws_secretsmanager_secret-admin_password.arn

    rw_username     = var.rw_user
    rw_password-arn = var.aws_secretsmanager_secret-rw_user_password.arn

    ro_username     = var.ro_user
    ro_password-arn = var.aws_secretsmanager_secret-ro_user_password.arn

    region    = data.aws_region.current.name
    log_group = aws_cloudwatch_log_group.influxdb.name
  }
}

data "template_file" "influxdb-efs" {
  template = file("${path.module}/task-definitions/influxdb-efs.tpl")

  vars = {
    cpu    = var.cpu
    memory = var.memory
    auth_enabled    = var.auth_enabled

    db_name            = var.name
    admin_username     = var.admin_user
    admin_password-arn = var.aws_secretsmanager_secret-admin_password.arn

    rw_username     = var.rw_user
    rw_password-arn = var.aws_secretsmanager_secret-rw_user_password.arn

    ro_username     = var.ro_user
    ro_password-arn = var.aws_secretsmanager_secret-ro_user_password.arn

    region    = data.aws_region.current.name
    log_group = aws_cloudwatch_log_group.influxdb.name
  }
}


resource "aws_ecs_task_definition" "influxdb-efs" {
  count                 = var.use_efs ? 1 : 0
  family                = "${var.name}-${terraform.workspace}-influxdb"
  container_definitions = data.template_file.influxdb-efs.rendered

  task_role_arn      = var.task_role.arn
  execution_role_arn = var.execution_role.arn

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

  volume {
    name = "influxdb-storage"

    efs_volume_configuration {
      file_system_id = aws_efs_file_system.influxdb[0].id
    }
  }

  tags = var.tags
}

resource "aws_ecs_task_definition" "influxdb" {
  count                 = var.use_efs ? 0 : 1
  family                = "${var.name}-${terraform.workspace}-influxdb"
  container_definitions = data.template_file.influxdb.rendered

  task_role_arn      = var.task_role.arn
  execution_role_arn = var.execution_role.arn

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

  tags = var.tags
}

resource "aws_ecs_service" "influxdb" {
  name             = "${var.name}-${terraform.workspace}-influxdb"
  cluster          = var.aws_ecs_cluster.id
  task_definition  = var.use_efs ? aws_ecs_task_definition.influxdb-efs[0].arn : aws_ecs_task_definition.influxdb[0].arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0" #This should be latest but that defaults to 1.3 right now

  network_configuration {
    security_groups = [var.aws_security_group.id]

    assign_public_ip = true
    subnets          = var.aws_subnets.*.id
  }

  service_registries {
    registry_arn = aws_service_discovery_service.influxdb.arn
  }

  tags           = var.tags
  propagate_tags = "TASK_DEFINITION"
}

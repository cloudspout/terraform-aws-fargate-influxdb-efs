provider "aws" {
  # No secrets here - Use env. variables or the ~/.aws/credentials
  # https://www.terraform.io/docs/providers/aws/index.html
  version = "~> 2.63.0"
  region  = "us-east-1"
}

resource "aws_service_discovery_private_dns_namespace" "example" {
  name = "example.local"
  vpc  = aws_vpc._.id
}

locals {
  common_tags = {
    source = "example"
    env    = terraform.workspace
  }

  admin_user = "admin"
  rw_user    = "rw_user"
  ro_user    = "ro_user"
}

resource "aws_security_group" "influxdb_access" {
  name        = "Example-${terraform.workspace}-influxdb_access"
  description = "Allow access to the Influxdb"
  vpc_id      = aws_vpc._.id

  ingress {
    from_port = 8086
    to_port   = 8086
    protocol  = "tcp"
    // Limit it
  }

  tags = merge(local.common_tags, {
    Name = "Example-${terraform.workspace}-influxdb_access"
  })
}

resource "aws_ecs_cluster" "_" {
  name = "Example-${terraform.workspace}"

  capacity_providers = ["FARGATE"]

  tags = local.common_tags
}


module "ecs_efs" {
  source  = "cloudspout/fargate-influxdb-efs/aws"
  version = "0.0.1"

  name                                        = "Example"
  tags                                        = local.common_tags
  aws_service_discovery_private_dns_namespace = aws_service_discovery_private_dns_namespace.example


  aws_ecs_cluster = aws_ecs_cluster._
  cpu             = 512
  memory          = 2048

  execution_role = aws_iam_role.influxdb_execution
  task_role      = aws_iam_role.influxdb

  admin_user                                 = local.admin_user
  aws_secretsmanager_secret-admin_password   = aws_secretsmanager_secret_version.influxdb_admin-password
  rw_user                                    = local.rw_user
  aws_secretsmanager_secret-rw_user_password = aws_secretsmanager_secret_version.influxdb_rw_user-password
  ro_user                                    = local.ro_user
  aws_secretsmanager_secret-ro_user_password = aws_secretsmanager_secret_version.influxdb_ro_user-password

  aws_vpc            = aws_vpc._
  aws_subnets        = aws_subnet._
  aws_security_group = aws_security_group.influxdb_access
}


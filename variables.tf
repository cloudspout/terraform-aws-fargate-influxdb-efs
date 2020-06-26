variable "use_efs" {
  type        = bool
  default     = true
  description = "Create EFS resource and use it for InfluxDB's data storage"
}

variable "aws_vpc" {
  type        = object({ id : string })
  description = "VPC to place ECS task and security groups into"
}

variable "aws_subnets" {
  type        = list(object({ id : string }))
  description = "VPC to place ECS task onto"
}

variable "aws_service_discovery_private_dns_namespace" {
  type        = object({ id : string })
  description = "Namespace to register InfluxDB service under"
}

variable "aws_security_group" {
  type        = object({ id : string })
  description = "SG for the ECS task"
}

variable "aws_ecs_cluster" {
  type        = object({ id : string })
  description = "ECS cluster to place InfluxDB task on"
}

variable "task_role" {
  type        = object({ arn : string })
  description = "Role to run ECS InfluxDB task under"
}

variable "execution_role" {
  type        = object({ arn : string })
  description = "Role to start ECS InfluxDB task from"
}

variable "cpu" {
  type        = number
  description = "vCPUs for ECS InfluxDB task"
}

variable "memory" {
  type        = number
  description = "Memory in MB for ECS InfluxDB task"
}

variable "auth_enabled" {
  type        = bool
  default     = true
  description = "Enables authentication"
}

variable "admin_user" {
  type        = string
  default     = "admin"
  description = "Username of the InfluxDB admin user"
}

variable "aws_secretsmanager_secret-admin_password" {
  type        = object({ arn : string })
  description = "Password of the InfluxDB admin user stored as Secrets Manager secret"
}

variable "rw_user" {
  type        = string
  default     = "rw"
  description = "Username of the InfluxDB RW user"
}

variable "aws_secretsmanager_secret-rw_user_password" {
  type        = object({ arn : string })
  description = "Password of the InfluxDB RW user stored as Secrets Manager secret"
}

variable "ro_user" {
  type        = string
  default     = "ro"
  description = "Username of the InfluxDB RO user"
}

variable "aws_secretsmanager_secret-ro_user_password" {
  type        = object({ arn : string })
  description = "Password of the InfluxDB RO user stored as Secrets Manager secret"
}

variable "name" {
  type        = string
  default     = "example"
  description = "Name used to build resource names"
}

variable "tags" {
  type        = map
  description = "Tags assigned to every AWS resource"
}

variable "retention_in_days" {
  type        = number
  default     = 1
  description = "Retention period for the Cloudwatch-based ECS logs"
}
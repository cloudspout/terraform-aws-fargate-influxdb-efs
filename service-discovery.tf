resource "aws_service_discovery_service" "influxdb" {
  name = "${var.name}-influxdb"

  dns_config {
    namespace_id = var.aws_service_discovery_private_dns_namespace.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
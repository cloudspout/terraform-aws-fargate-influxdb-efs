[
    {
      "name": "influxdb",
      "image": "influxdb:1.6",
      "cpu": ${cpu},
      "memory": ${memory},
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8086,
          "hostPort": 8086
        }
      ],
      "environment": [
        {
          "name": "INFLUXDB_DB",
          "value": "${db_name}"
        },
        {
          "name": "INFLUXDB_HTTP_AUTH_ENABLED",
          "value": "true"
        },
        {
          "name": "INFLUXDB_ADMIN_USER",
          "value": "${admin_username}"
        },
        {
          "name": "INFLUXDB_READ_USER",
          "value": "${rw_username}"
        },
        {
          "name": "INFLUXDB_WRITE_USER",
          "value": "${rw_username}"
        }
      ],
      "secrets": [
        {
          "name": "INFLUXDB_ADMIN_PASSWORD",
          "valueFrom": "${admin_password-arn}"
        },
        {
          "name": "INFLUXDB_READ_USER_PASSWORD",
          "valueFrom": "${rw_password-arn}"
        },
        {
          "name": "INFLUXDB_WRITE_USER_PASSWORD",
          "valueFrom": "${ro_password-arn}"
        }
      ],
      "mountPoints": [
        {
          "containerPath": "/var/lib/influxdb",
          "sourceVolume": "influxdb-storage"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${log_group}",
          "awslogs-region": "${region}",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
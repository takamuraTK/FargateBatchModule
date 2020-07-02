# CloudWatch
resource "aws_cloudwatch_log_group" "fargate" {
  name = "/ecs_scheduled_tasks/${var.basename}_fargate"
  retention_in_days = 180
}

resource "aws_cloudwatch_event_rule" "fargate" {
  name = "${var.basename}_fargate"
  description = "These are the event rules for FargateBatch."
  schedule_expression = var.cron
}

resource "aws_cloudwatch_event_target" "fargate" {
  target_id = "${var.basename}_fargate"
  rule = aws_cloudwatch_event_rule.fargate.name
  role_arn = var.ecs_event_role_arn
  arn = aws_ecs_cluster.fargate_cluster.arn

  ecs_target {
    launch_type = "FARGATE"
    task_count = 1
    platform_version = "1.3.0"
    task_definition_arn = aws_ecs_task_definition.fargate.arn

    network_configuration {
      subnets = var.subnets
      security_groups = var.security_groups
      assign_public_ip = true
    }
  }
}

# ECS Resources
resource "aws_ecs_cluster" "fargate_cluster" {
  name = var.basename
}

resource "aws_ecs_task_definition" "fargate" {
  family = "${var.basename}_fargate"
  cpu = var.cpu
  memory = var.memory
  container_definitions    = data.template_file.batch_task_difinition.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  task_role_arn            = var.ecs_task_role_arn
  execution_role_arn       = var.ecs_task_role_arn
}

data "template_file" "batch_task_difinition" {
  template = file("${path.module}/batch_container.json")
  vars = {
    container_name = "${var.basename}_container"
    image = var.image
    region = var.region
    logs_group = "/ecs_scheduled_tasks/${var.basename}_fargate"
    log_bucket_name = aws_s3_bucket.log_bucket.bucket
    command = var.command
  }
}

# S3
resource "aws_s3_bucket" "log_bucket" {
    bucket = "${var.basename}-tesla-logs-bucket"

    lifecycle_rule {
        enabled = true

        expiration {
            days = "180"
        }
    }
}

resource "aws_s3_bucket_public_access_block" "private" {
    bucket = aws_s3_bucket.log_bucket.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}
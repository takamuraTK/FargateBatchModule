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
  role_arn = module.ecs_event_role.iam_role_arn
  arn = aws_ecs_cluster.ecs_cluster.arn

  ecs_target {
    launch_type = "FARGATE"
    task_count = 1
    platform_version = "1.3.0"
    task_definition_arn = aws_ecs_task_definition.fargate.arn

    network_configuration {
      subnets = [aws_subnet.public_subnet.id]
      security_groups = [aws_security_group.public_sg.id]
      assign_public_ip = true
    }
  }
}
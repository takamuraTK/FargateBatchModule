module "fargate" {
  basename           = var.basename
  source             = "../../"
  cron               = "cron(*/2 * * * ? *)"
  cpu                = "256"
  memory             = "512"
  region             = var.region
  ecs_task_role_arn  = aws_iam_role.fargate_task.arn
  ecs_event_role_arn = aws_iam_role.fargate_event.arn
  security_groups    = [aws_security_group.fargate.id]
  subnets            = [module.vpc.subnet_id]
  container_definitions = jsonencode([
    {
      name      = var.basename
      image     = "nginx:latest"
      essential = true
      portMappings = [
        {
          containerPort = "80"
          protocol      = "tcp"
        }
      ]
    }
  ])
}

module "vpc" {
  source            = "git::https://github.com/takamuraTK/terraform-aws-vpc.git"
  basename          = var.basename
  vpc_cidr_block    = "10.0.0.0/16"
  subnet_cidr_block = "10.0.0.0/24"
}
module "ecs_event_role" {
  source     = "./modules/iam_role"
  name       = "${var.basename}_ecs_event_role"
  identifier = "events.amazonaws.com"
  policy     = data.aws_iam_policy.ecs_events_role_policy.policy
}

data "aws_iam_policy" "ecs_events_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

module "ecs_task_role" {
  source     = "./modules/iam_role"
  name       = "${var.basename}_ecs_task_role"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy.ecs_task_role_policy.policy
}

data "aws_iam_policy" "ecs_task_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

# 条件分岐で必要なときのみにしたい
module "security_group" {
  name        = var.basename
  source      = "./modules/security_group"
  vpc_id      = "22"
  port        = "512"
  cidr_blocks = ["0.0.0.0/0"]
}

# 条件分岐で必要なときのみにしたい
resource "aws_vpc" "fargate_vpc" {
  cidr_block = "10.0.0.0/16"
  tags       = { Name = var.basename }
}

resource "aws_subnet" "fargate_subnet" {
  vpc_id     = aws_vpc.fargate_vpc.id
  cidr_block = "10.0.0.0/24"
}

module "fargate" {
  basename           = var.basename
  source             = "./modules/fargate"
  cron               = "cron(*/2 * * * ? *)"
  cpu                = "256"
  memory             = "512"
  region             = var.region
  ecs_task_role_arn  = module.ecs_task_role.iam_role_arn
  ecs_event_role_arn = module.ecs_event_role.iam_role_arn
  security_groups    = [module.security_group.security_group_id]
  subnets            = [aws_subnet.fargate_subnet.id]
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
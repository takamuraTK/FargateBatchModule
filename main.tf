module "ecs_event_role" {
  source = "./modules/iam_role"
  name = "${var.basename}_ecs_event_role"
  identifier = "events.amazonaws.com"
  policy = data.aws_iam_policy.ecs_events_role_policy.policy
}

data "aws_iam_policy" "ecs_events_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

module "ecs_task_role" {
  source = "./modules/iam_role"
  name = "${var.basename}_ecs_task_role"
  identifier = "ecs-tasks.amazonaws.com"
  policy = aws_iam_policy.ecs_events_role_policy.policy
}

data "aws_iam_policy" "ecs_task_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

module "fargate" {
  basename = var.basename
  source = "./modules/fargate"
  cron = "cron(*/2 * * * ? *)"
  cpu = "256"
  memory = "512"
  image = "hello-world"
  region = var.region
}
# ECS event role
resource "aws_iam_role" "fargate_event" {
  name               = var.basename
  assume_role_policy = data.aws_iam_policy_document.fargate_event.json
}

data "aws_iam_policy_document" "fargate_event" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "fargate_event" {
  name   = "${var.basename}_fargate_event_policy"
  policy = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

resource "aws_iam_role_policy_attachment" "fargate_event" {
  role       = aws_iam_role.fargate_event.name
  policy_arn = data.aws_iam_policy.fargate_event.arn
}


# ECS task role
resource "aws_iam_role" "fargate_task" {
  name               = "${var.basename}_task_role"
  assume_role_policy = data.aws_iam_policy_document.fargate_task.json
}

data "aws_iam_policy_document" "fargate_task" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "fargate_task" {
  name   = "${var.basename}_task_policy"
  policy = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

resource "aws_iam_role_policy_attachment" "fargate_task" {
  role       = aws_iam_role.fargate_task.name
  policy_arn = aws_iam_policy.fargate_task.arn
}
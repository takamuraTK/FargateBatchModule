module "fargate" {
  basename           = var.basename
  source             = "../../"
  cron               = "cron(*/2 * * * ? *)"
  cpu                = "256"
  memory             = "512"
  region             = var.region
  security_groups    = [module.vpc.security_group_id]
  subnets            = [module.vpc.subnet_id]
  container_definitions = jsonencode([
    {
      name      = var.basename
      image     = "nginx:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

module "vpc" {
  source            = "git::https://github.com/takamuraTK/terraform-aws-vpc.git"
  basename          = "fargate_vpc"
  vpc_cidr_block    = "10.0.0.0/16"
  subnet_cidr_block = "10.0.0.0/24"
  sg_port           = "80"
  sg_cidr_blocks    = ["0.0.0.0/0"]
}
variable basename {}
variable cron {}
variable cpu {}
variable memory {}
variable region {}
variable image {}
variable ecs_task_role_arn {}
variable ecs_event_role_arn {}
variable command {}
variable security_groups {
    type = list(string)
}
variable subnets {
    type = list(string)
}
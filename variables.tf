variable basename {
  type        = string
  description = "各リソースに付与される先頭の名前"
}

variable cron {
  type        = string
  description = "バッチのcron式"
}

variable cpu {
  default     = "256"
  type        = string
  description = "タスクレベルのCPU設定"
}

variable memory {
  default     = "512"
  type        = string
  description = "タスクレベルのメモリ設定"
}

variable region {
  type        = string
  description = "タスクログのリージョン"
}

variable ecs_task_role_arn {
  type        = string
  description = "タスクロール、アプリケーションが使用する権限を付与するIAMロール"
}
variable ecs_event_role_arn {
  type        = string
  description = "CloudWatchイベントからECSを起動する権限を持つIAMロール"
}

variable security_groups {
  type        = list(string)
  description = "タスクに設定されるセキュリティグループ"
}

variable subnets {
  type        = list(string)
  description = "タスクに設定されるサブネット"
}

variable container_definitions {
  type = string
  description = "JSON形式のタスク定義"
}
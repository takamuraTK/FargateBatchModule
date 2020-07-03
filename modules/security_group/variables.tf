variable "name" {
  type = string
  description = "セキュリティグループ名"
}

variable "vpc_id" {
  type = string
  description = "セキュリティグループを設定するVPCのID"
}

variable "port" {
  type = string
  description = "インバウンドに設定するポート番号"
}

variable "cidr_blocks" {
    type = list(string)
    description = "インバウンドを許可するCIDRブロック"
}

variable "name" {
  type    = string
  default = "techchallenge"
}

variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/24"
}

variable "app_version" {
  type    = string
  default = "v.0.7.0"
}

variable "db_name" {
  type    = string
  default = "app"
}

variable "db_username" {
  type    = string
  default = "postgres"
}

variable "db_password" {
  type    = string
  default = "changeme"
}

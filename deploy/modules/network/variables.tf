variable "name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "zones" {
  type    = list(string)
  default = ["a"]
}


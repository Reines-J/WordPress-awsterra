variable "region"{
  description = "project region"
  default = "ap-northeast-2"
}
variable "name" {
  description = "tag name"
}
variable "vpc_name" {
  description = "VPC name"
}

variable "cidr" {
  default = "vpc cidr"
}

variable "cidr_public" {
  default = {
      "0" = "1"
      "1" = "2"
  }
}

variable "cidr_private" {
  default = {
      "0" = "3"
      "1" = "4"
  }
}

variable "az" {
  type = list(string)
  description = "Availability Zones"
}


variable "cl-allow" {
  type = list(string)
  description = "allow method"
}

variable "cl-cached" {
  type = list(string)
  description = "cached method"
}
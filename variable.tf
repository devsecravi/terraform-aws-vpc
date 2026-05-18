variable "project" {
    type = string
}

variable "environment"{
    type= string
}

variable "vpc_cidr"{

    type = string
    default = "10.0.0.0/16"
}

variable "vpc_tags" {
    type = map
    default = {}
}

variable "igw_tags" {
    type = map
    default = {}
}

variable "sb_tags_us_east_1a"{
    type = map
    default = {}
}

variable "sb_tags_us_east_1b"{
    type = map
    default = {}
}
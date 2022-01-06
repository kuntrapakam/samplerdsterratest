variable "allocated_storage" {
    default = 10
}

variable "engine" {
    default = "mysql"
}

variable "engine_version" {
  default = "5.7"
}

variable "instance_class" {
    type = string
    description = "(optional) describe your variable"
    default = "db.t2.micro"
}

variable "name" {
  default = "amazonaurora"
}

variable "username" {
  default = "simpleuser"
}

variable "password" {
    default = "simpleuser"
}

variable "port" {
  default = "3306"
}
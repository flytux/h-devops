
variable "PUBLIC_SUBNETS" {
  default = {
    web = 10
    mgt = 50
  }
}

variable "PRIVATE_SUBNETS" {
  default = {
    ap  = 20
    db  = 30
    fep = 40
    mgt = 51
  }
}

variable "PRIVATE_LB_SUBNETS" {
  default = {
    pub = 200
    pri = 210
  }
}
/*
variable "PUBLIC_SERVER_LIST" {
  default = {}
}

variable "PRIVATE_SERVER_LIST" {
  default = {}
}
*/
variable "APP_NAME" {
  type = string
}

variable "ENV" {
  type = string
}

variable "ZONE" {
  type = string
}
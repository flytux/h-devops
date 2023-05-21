
variable "CLUSTER_TYPE" {
  default = "SVR.VNKS.STAND.C002.M008.NET.SSD.B050.G002" # 10ea
}

variable "K8S_VERSION" {
  default = "1.24.10"
}

variable "LOGIN_KEY_NAME" {
  default = "cn-hro-test"
}

variable "APP_NAME" {
  type = string
}


variable "ENV" {
  type = string
}

variable "LB_PRIVATE_SUBNET_NO" {
  type = list(any)
}

variable "NODE_POOLS" {
  default = {}
}

variable "NETWORK_PLUGIN" {
  default = "cilium"
}

variable "SUBNET_NO_LIST" {
  type = list(any)
}

variable "VPC_ID" {
  type = string
}
variable "ZONE" {
  default = "FKR-1"
}

variable "LOG_AUDIT" {
  default = false
}
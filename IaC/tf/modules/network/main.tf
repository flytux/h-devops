# VPC
resource "ncloud_vpc" "main" {
  name            = "vpc-${var.APP_NAME}-${var.ENV}"
  ipv4_cidr_block = "10.3.0.0/16"
}


# Subnets
resource "ncloud_subnet" "main-private-subnets" {
  for_each = var.PRIVATE_SUBNETS

  name           = "sn-${var.APP_NAME}-${var.ENV}-${each.key}-pri"
  vpc_no         = ncloud_vpc.main.id
  subnet         = "10.3.${each.value}.0/24"
  zone           = var.ZONE
  network_acl_no = ncloud_vpc.main.default_network_acl_no
  subnet_type    = "PRIVATE"
  usage_type     = "GEN"
}

resource "ncloud_subnet" "main-public-subnets" {
  for_each = var.PUBLIC_SUBNETS

  name           = "sn-${var.APP_NAME}-${var.ENV}-${each.key}-pub"
  vpc_no         = ncloud_vpc.main.id
  subnet         = "10.3.${each.value}.0/24"
  zone           = var.ZONE
  network_acl_no = ncloud_vpc.main.default_network_acl_no
  subnet_type    = "PUBLIC"
  usage_type     = "GEN"
}

resource "ncloud_subnet" "main-private-lb-subnets" {
  for_each = var.PRIVATE_LB_SUBNETS

  name           = "sn-${var.APP_NAME}-${var.ENV}-lb-${each.key}"
  vpc_no         = ncloud_vpc.main.id
  subnet         = "10.3.${each.value}.0/24"
  zone           = var.ZONE
  network_acl_no = ncloud_vpc.main.default_network_acl_no
  subnet_type    = "PRIVATE"
  usage_type     = "LOADB"
}


# NAT Gateway
resource "ncloud_nat_gateway" "main-nat-gateway" {
  name   = "nat-${var.APP_NAME}-${var.ENV}"
  vpc_no = ncloud_vpc.main.id
  zone   = var.ZONE
}
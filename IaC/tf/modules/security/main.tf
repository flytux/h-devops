#ACG Default Group(VPC)
/* -> duplicate
resource "ncloud_access_control_group" "vpc-acg" {
  # defualt VPC
  name        = "vpc-${var.APP_NAME}-${var.ENV}-default-acg"
  description = "VPC[vpc-${var.APP_NAME}-${var.ENV}] default ACG"
  vpc_no      = var.VPC_ID
}
*/

#ACG Group(HOST)
resource "ncloud_access_control_group" "instance-acg" {

  for_each = var.SERVER_LIST

  name        = "acg-${var.APP_NAME}-${var.ENV}-${each.value["name"]}"
  vpc_no      = var.VPC_ID
  description = "${each.value["name"]}-apply"
}

resource "ncloud_access_control_group_rule" "acg-rule" {

  for_each                = var.SERVER_LIST
  access_control_group_no = ncloud_access_control_group.instance-acg["${each.key}"].id

  dynamic "inbound" {
    for_each = var.SERVER_LIST["${each.key}"].inbound
    content {
      protocol    = inbound.value[0]
      ip_block    = inbound.value[1] # web console에서는 ACG이름을 입력가능하나 tf에서는 불가
      port_range  = inbound.value[2]
      description = inbound.value[3]
    }
  }

  dynamic "outbound" {
    for_each = var.SERVER_LIST["${each.key}"].outbound
    content {
      protocol    = outbound.value[0]
      ip_block    = outbound.value[1]
      port_range  = outbound.value[2]
      description = outbound.value[3]
    }
  }
}

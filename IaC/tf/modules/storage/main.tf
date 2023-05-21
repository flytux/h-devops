#Block Storage(SW)
resource "ncloud_block_storage" "storage_sw" {
  for_each = var.SERVER_LIST

  server_instance_no = lookup(var.INSTANCE_LIST, "${var.APP_NAME}-${var.ENV}-${each.key}").id
  name               = "${var.APP_NAME}-${var.ENV}-${each.key}-sw"
  size               = each.value["storage"]["sw"]["size"]
}

/****
#Block Storage(APP)
resource "ncloud_block_storage" "storage_app" {
  for_each = var.SERVER_LIST

  server_instance_no = lookup(var.INSTANCE_LIST, "${var.APP_NAME}-${var.ENV}-${each.key}").id
  name               = "${var.APP_NAME}-${var.ENV}-${each.key}-app"
  size               = each.value["storage"]["app"]["size"]
}

#Block Storage(DATA)
resource "ncloud_block_storage" "storage_data" {
  for_each = var.SERVER_LIST

  server_instance_no = lookup(var.INSTANCE_LIST, "${var.APP_NAME}-${var.ENV}-${each.key}").id
  name               = "${var.APP_NAME}-${var.ENV}-${each.key}-data"
  size               = each.value["storage"]["data"]["size"]
}
****/

/*
#NAS
resource "ncloud_nas_volume" "nas" {
  volume_name_postfix            = "${var.APP_NAME}-${var.ENV}"
  volume_size                    = "600"
  volume_allotment_protocol_type = "NFS"
}
*/
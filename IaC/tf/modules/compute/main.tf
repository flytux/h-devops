data "ncloud_server_images" "images" {
  /*
  filter {
    name   = "product_name"
    values = ["Red Hat Enterprise Linux 8.6 (64-bit)"]
  }
*/
  output_file = "ncloud_server_images.json"
}

data "ncloud_server_products" "products" {
  server_image_product_code = "SW.VSVR.OS.LNX64.RHEL.0806.B050.H001" // Red Hat Enterprise Linux 8.6 (64-bit)
  output_file               = "ncloud_server_products.json"
}


# Init Sciprt
resource "ncloud_init_script" "init" {
  name        = "mtp-base-init"
  os_type     = "LNX"
  description = "mtp, hro 관리자 계정 추가"
  content     = file("${path.module}/init.sh")
}


resource "ncloud_server" "server" {
  for_each = var.SERVER_LIST

  name      = "${var.APP_NAME}-${var.ENV}-${each.key}"
  subnet_no = lookup(var.SUBNET_LIST, "sn-${var.APP_NAME}-${var.ENV}-${each.value["subnet_group"]}-${each.value["type"]}").id
  # ref : sn-hello-hro-dev-ap-pri

  server_product_code       = each.value["server_product_code"]
  server_image_product_code = each.value["image_product_code"]

  network_interface {
    network_interface_no = ncloud_network_interface.nic["${each.key}"].id
    order                = 0
  }

  init_script_no = ncloud_init_script.init.id

  tag_list {
    tag_key   = "ansible_group"
    tag_value = each.value["ansible_group"]
  }
  tag_list {
    tag_key   = "tf"
    tag_value = formatdate("YYYY-MM-DD-hh:mm:ss", timestamp())
  }

  tag_list {
    tag_key   = "tier"
    tag_value = each.value["tier"]
  }

}

# NIC - network module에서 구현이 어려움
resource "ncloud_network_interface" "nic" {

  for_each = var.SERVER_LIST

  name                  = "nic-${var.APP_NAME}-${var.ENV}-${each.value["name"]}" ## default로 지정시 간헐적으로 dulpcation 발생
  subnet_no             = lookup(var.SUBNET_LIST, "sn-${var.APP_NAME}-${var.ENV}-${each.value["subnet_group"]}-${each.value["type"]}").id
  access_control_groups = [lookup(var.ACG_LIST, "acg-${var.APP_NAME}-${var.ENV}-${each.value["name"]}")]
}


resource "ncloud_public_ip" "pulbic_ip" {

  for_each           = { for type, svr in var.SERVER_LIST : type => svr if svr["type"] == "pub" }
  server_instance_no = lookup(var.INSTANCE_LIST, "${var.APP_NAME}-${var.ENV}-${each.key}").id
}
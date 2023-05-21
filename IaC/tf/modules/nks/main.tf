# NKS
resource "ncloud_nks_cluster" "cluster" {
  cluster_type         = var.CLUSTER_TYPE
  k8s_version          = var.K8S_VERSION
  login_key_name       = var.LOGIN_KEY_NAME
  name                 = "nks-${var.APP_NAME}-${var.ENV}"
  lb_private_subnet_no = var.LB_PRIVATE_SUBNET_NO[0]
  kube_network_plugin  = var.NETWORK_PLUGIN
  subnet_no_list       = [var.SUBNET_NO_LIST[0]]
  vpc_no               = var.VPC_ID
  zone                 = var.ZONE
  log {
    audit = var.LOG_AUDIT
  }
}

resource "ncloud_nks_node_pool" "node_pool" {

  for_each = var.NODE_POOLS

  cluster_uuid = ncloud_nks_cluster.cluster.uuid
  subnet_no    = var.SUBNET_NO_LIST[0]

  node_pool_name = each.value["name"]
  node_count     = each.value["node_count"]
  product_code   = each.value["product_code"]

  autoscale {
    enabled = each.value["autoscale"]["enable"]
    min     = each.value["autoscale"]["min"]
    max     = each.value["autoscale"]["max"]
  }
}

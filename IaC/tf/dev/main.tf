# VPC
module "network" {
  source = "../modules/network"

  APP_NAME = var.APP_NAME
  ENV      = var.ENV
  ZONE     = var.ZONE
}

# Security(ACG)
module "security" {
  depends_on = [module.network]
  source     = "../modules/security"

  VPC_ID      = module.network.main-vpc-id
  SERVER_LIST = local.CONFIG_LIST
  APP_NAME    = var.APP_NAME
  ENV         = var.ENV
  ZONE        = var.ZONE
}

# COMPUTE(Server)
module "compute" {
  depends_on = [module.security]
  source     = "../modules/compute"

  SUBNET_LIST   = module.network.list-subnets
  SERVER_LIST   = local.CONFIG_LIST
  INSTANCE_LIST = module.compute.list-servers
  ACG_LIST      = module.security.list-server-acg
  APP_NAME      = var.APP_NAME
  ENV           = var.ENV
  ZONE          = var.ZONE
}

/*
# NKS ( to-do nks acg )
module "nks" {
  depends_on = [module.security]
  source     = "../modules/nks"

  VPC_ID               = module.network.main-vpc-id
  CLUSTER_TYPE         = local.CLUSTER_TYPE
  K8S_VERSION          = local.K8S_VERSION
  LB_PRIVATE_SUBNET_NO = module.network.private-lb-subnets
  SUBNET_NO_LIST       = module.network.subnet-private
  LOGIN_KEY_NAME       = local.LOGIN_KEY_NAME
  APP_NAME             = var.APP_NAME
  NODE_POOLS           = local.NODE_POOLS
  ENV                  = var.ENV
  ZONE                 = var.ZONE
  LOG_AUDIT            = local.LOG_AUDIT
}
*/


# STORAGE(Block Storage, NAS)

module "storage" {
  depends_on = [module.compute]
  source     = "../modules/storage"

  SERVER_LIST   = local.CONFIG_LIST
  INSTANCE_LIST = module.compute.list-servers
  APP_NAME      = var.APP_NAME
  ENV           = var.ENV
  ZONE          = var.ZONE
}


resource "local_file" "ansible_inventory" {
  depends_on = [module.compute]

  content         = local.ansible_inventory
  filename        = "${path.root}/ansible_hosts"
  file_permission = "644"
}
# Authentication
variable "ACCESS_KEY" {
  default = "C2AF5118B23A1E190253"
}

variable "SECRET_KEY" {
  default = "7E92A25543BDE8696F4E2FA7D093BFD42AE9089B"
}

# Basic Info
variable "APP_NAME" {
  default = "hello-hro"
}

variable "ENV" {
  default = "dev"
}

variable "REGION" {
  default = "FKR"
}

variable "ZONE" {
  default = "FKR-1"
}

variable "SUPPORT_VPC" {
  default = false
}

## Instance Settings
locals {
  OS_TYPE      = "SW.VSVR.OS.LNX64.RHEL.0806.B050.H001"       //Red Hat Enterprise Linux 8.6 (64-bit)
  VM_SPEC_MIN  = "SVR.VSVR.STAND.C002.M004.NET.HDD.B050.G001" //vCPU 2EA, Memory 4GB, Disk 50GB
  VM_SPEC_STD  = "SVR.VSVR.STAND.C002.M004.NET.HDD.B050.G001" //vCPU 2EA, Memory 4GB, Disk 50GB
  VM_SPEC_HIGH = "SVR.VSVR.STAND.C002.M004.NET.HDD.B050.G001" //vCPU 2EA, Memory 4GB, Disk 50GB
}

## NKS Settings
locals {
  CLUSTER_TYPE   = "SVR.VNKS.STAND.C002.M008.NET.HDD.B050.G001" #10ea
  K8S_VERSION    = "1.24.10-nks.1"
  LOGIN_KEY_NAME = "cn-hro-test"
  NETWORK_PLUGIN = "cilium"
  LOG_AUDIT      = false

  NODE_POOLS = {
    nood_pool_01 = {
      name         = "nood-pool"
      node_count   = 3
      product_code = "SVR.VSVR.STAND.C002.M004.NET.SSD.B050.G001" # [Standard] vCPU 2EA, Memory 4GB , [SSD]Disk 50GB
      autoscale = {
        enable = true
        min    = 1
        max    = 2
      }
    }
  }
}


## Block Storage Path Settings
locals {
  # mount는 ansible로 실행
  STORAGE_ROOT_VG = "/hro_app"

  STORAGE_SW_LV  = "/sw"  # S/W설치
  STORAGE_APP_LV = "/app" # Source배포
  STORAGE_LOG_LV = "/log" # Logging

  STORAGE_DATA_LV = "/data"
}


## Instance Settings (MAIN)
locals {
  CONFIG_LIST = {

    coreweb = {
      idx                 = 0
      name                = "coreweb"
      type                = "pri"
      subnet_group        = "ap"
      tier                = "frontend"
      ansible_group       = "webserver"
      storage_size        = "10"
      image_product_code  = local.OS_TYPE
      server_product_code = local.VM_SPEC_STD
      inbound = [
        ["TCP", "221.168.39.193/32", "22", "SSH@BASTION"]
      ]
      outbound = []
      storage = {
        sw = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_SW_LV}"
          size        = 10
        }
        app = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_APP_LV}"
          size        = 20
        }
        log = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_LOG_LV}"
          size        = 30
        }
        data = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_DATA_LV}"
          size        = 40
        }
      }
    }

    mciap = {
      idx                 = 1
      name                = "mciap"
      type                = "pri"
      subnet_group        = "ap"
      tier                = "solution"
      ansible_group       = "solution"
      image_product_code  = local.OS_TYPE
      server_product_code = local.VM_SPEC_STD
      inbound = [
        ["TCP", "221.168.39.193/32", "22", "SSH@BASTION"]
      ]
      outbound = []
      storage = {
        sw = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_SW_LV}"
          size        = 10
        }
        app = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_APP_LV}"
          size        = 20
        }
        log = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_LOG_LV}"
          size        = 30
        }
        data = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_DATA_LV}"
          size        = 40
        }
      }
    }

    fepap = {
      idx                 = 2
      name                = "fepap"
      type                = "pri"
      tier                = "solution"
      ansible_group       = "solution"
      subnet_group        = "fep"
      image_product_code  = local.OS_TYPE
      server_product_code = local.VM_SPEC_STD
      inbound = [
        ["TCP", "221.168.39.193/32", "22", "SSH@BASTION"]
      ]
      outbound = []
      storage = {
        sw = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_SW_LV}"
          size        = 10
        }
        app = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_APP_LV}"
          size        = 20
        }
        log = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_LOG_LV}"
          size        = 30
        }
        data = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_DATA_LV}"
          size        = 40
        }
      }
    }
    ssoeamap = {
      idx                 = 3
      name                = "ssoeamap"
      type                = "pri"
      subnet_group        = "ap"
      tier                = "solution"
      ansible_group       = "solution"
      image_product_code  = local.OS_TYPE
      server_product_code = local.VM_SPEC_STD
      inbound = [
        ["TCP", "221.168.39.193/32", "22", "SSH@BASTION"]
      ]
      outbound = []
      storage = {
        sw = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_SW_LV}"
          size        = 10
        }
        app = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_APP_LV}"
          size        = 20
        }
        log = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_LOG_LV}"
          size        = 30
        }
        data = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_DATA_LV}"
          size        = 40
        }
      }
    }
    edmsap = {
      idx                 = 4
      name                = "edmsap"
      type                = "pri"
      subnet_group        = "ap"
      tier                = "solution"
      ansible_group       = "solution"
      image_product_code  = local.OS_TYPE
      server_product_code = local.VM_SPEC_STD
      inbound = [
        ["TCP", "221.168.39.193/32", "22", "SSH@BASTION"]
      ]
      outbound = []
      storage = {
        sw = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_SW_LV}"
          size        = 10
        }
        app = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_APP_LV}"
          size        = 20
        }
        log = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_LOG_LV}"
          size        = 30
        }
        data = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_DATA_LV}"
          size        = 40
        }
      }
    }
    reportap = {
      idx                 = 5
      name                = "reportap"
      type                = "pri"
      subnet_group        = "ap"
      tier                = "solution"
      ansible_group       = "solution"
      image_product_code  = local.OS_TYPE
      server_product_code = local.VM_SPEC_STD
      inbound = [
        ["TCP", "221.168.39.193/32", "22", "SSH@BASTION"]
      ]
      outbound = []
      storage = {
        sw = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_SW_LV}"
          size        = 10
        }
        app = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_APP_LV}"
          size        = 20
        }
        log = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_LOG_LV}"
          size        = 30
        }
        data = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_DATA_LV}"
          size        = 40
        }
      }
    }
    webfaxap = {
      idx                 = 6
      name                = "webfaxap"
      type                = "pri"
      tier                = "solution"
      ansible_group       = "solution"
      subnet_group        = "fep"
      image_product_code  = local.OS_TYPE
      server_product_code = local.VM_SPEC_STD
      inbound = [
        ["TCP", "221.168.39.193/32", "22", "SSH@BASTION"]
      ]
      outbound = []
      storage = {
        sw = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_SW_LV}"
          size        = 10
        }
        app = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_APP_LV}"
          size        = 20
        }
        log = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_LOG_LV}"
          size        = 30
        }
        data = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_DATA_LV}"
          size        = 40
        }
      }
    }
    extfileap = {
      idx                 = 7
      name                = "extfileap"
      type                = "pri"
      tier                = "solution"
      ansible_group       = "solution"
      subnet_group        = "fep"
      image_product_code  = local.OS_TYPE
      server_product_code = local.VM_SPEC_STD
      inbound = [
        ["TCP", "221.168.39.193/32", "22", "SSH@BASTION"]
      ]
      outbound = []
      storage = {
        sw = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_SW_LV}"
          size        = 10
        }
        app = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_APP_LV}"
          size        = 20
        }
        log = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_LOG_LV}"
          size        = 30
        }
        data = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_DATA_LV}"
          size        = 40
        }
      }
    }

    chnlweb = {
      idx                 = 0
      name                = "chnlweb"
      type                = "pub"
      subnet_group        = "web"
      tier                = "frontend"
      ansible_group       = "webserver"
      image_product_code  = local.OS_TYPE
      server_product_code = local.VM_SPEC_STD
      inbound = [
        ["TCP", "221.168.39.193/32", "22", "SSH@BASTION"]
      ]
      outbound = []
      storage = {
        sw = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_SW_LV}"
          size        = 10
        }
        app = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_APP_LV}"
          size        = 20
        }
        log = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_LOG_LV}"
          size        = 30
        }
        data = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_DATA_LV}"
          size        = 40
        }
      }
    }
    proxyap = {
      idx                 = 1
      name                = "proxyap"
      type                = "pub"
      subnet_group        = "web"
      tier                = "frontend"
      ansible_group       = "webserver"
      image_product_code  = local.OS_TYPE
      server_product_code = local.VM_SPEC_STD
      inbound = [
        ["TCP", "221.168.39.193/32", "22", "SSH@BASTION"]
      ]
      outbound = []
      storage = {
        sw = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_SW_LV}"
          size        = 10
        }
        app = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_APP_LV}"
          size        = 20
        }
        log = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_LOG_LV}"
          size        = 30
        }
        data = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_DATA_LV}"
          size        = 40
        }
      }
    }
    solweb = {
      idx                 = 2
      name                = "solweb"
      type                = "pub"
      subnet_group        = "web"
      tier                = "frontend"
      ansible_group       = "webserver"
      image_product_code  = local.OS_TYPE
      server_product_code = local.VM_SPEC_STD
      inbound = [
        ["TCP", "221.168.39.193/32", "22", "SSH@BASTION"]
      ]
      outbound = []
      storage = {
        sw = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_SW_LV}"
          size        = 10
        }
        app = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_APP_LV}"
          size        = 20
        }
        log = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_LOG_LV}"
          size        = 30
        }
        data = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_DATA_LV}"
          size        = 40
        }
      }
    }
    metaap = {
      idx                 = 3
      name                = "metaap"
      type                = "pub"
      subnet_group        = "web"
      tier                = "solution"
      ansible_group       = "solution"
      image_product_code  = local.OS_TYPE
      server_product_code = local.VM_SPEC_STD
      inbound = [
        ["TCP", "211.204.87.46/32", "7305", "@PROJECT_SITE"],
        ["TCP", "211.204.87.46/32", "8080", "TOMCAT@PROJECT_SITE"], ["TCP", "221.168.39.193/32", "22", "SSH@BASTION"],
        ["TCP", "221.204.87.46/32", "22", "SSH@PROJECT_SITE"]
      ]
      outbound = [
        ["TCP", "0.0.0.0/0", "1-65535", "ob-memo"], ["UDP", "0.0.0.0/0", "1-65535", "ob-memo"],
        ["ICMP", "0.0.0.0/0", null, "ob-memo"]
      ]

      storage = {
        sw = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_SW_LV}"
          size        = 10
        }
        app = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_APP_LV}"
          size        = 20
        }
        log = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_LOG_LV}"
          size        = 30
        }
        data = {
          mount_point = "${local.STORAGE_ROOT_VG}+${local.STORAGE_DATA_LV}"
          size        = 40
        }
      }
    }

  }
}


# Ansible Host Settings
locals {
  ansible_inventory = templatefile(
    "${path.module}/ansible_inventory.tpl",
    {
      ansible_user_name = "swadmin"
      webserver_instances = {
        for instance_name, instance_info in module.compute.list-servers :
        instance_name => instance_info  if instance_info["tag"]["tag_value"] == "webserver"
      }

      solution_instances = {
        for instance_name, instance_info in module.compute.list-servers :
        instance_name => instance_info  if instance_info["tag"]["tag_value"] == "solution"
      }
    }
  )
}
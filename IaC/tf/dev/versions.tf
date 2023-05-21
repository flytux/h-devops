terraform {
  /*
  backend "http" {
    address = "https://hsnc20042901-2591201.devtools.fin-ncloud.com/2591201/cn-hro-test.git"
    lock_address = "http://myrest.api.com/foo"
    unlock_address = "http://myrest.api.com/foo"
  }
*/
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}
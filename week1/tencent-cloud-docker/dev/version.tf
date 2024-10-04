terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      version = "~> 1.81.0"
    }
  }
  backend "cos" {
    region = "ap-guangzhou"
    bucket = "terraform-state-1308378414"
    prefix = "tencent-cloud-docker/dev"
  }
}

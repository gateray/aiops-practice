terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      version = "~> 1.81.0"
    }
    helm = {
        source = "hashicorp/helm"
        version = "~> 2.14"
    }
  }
  backend "cos" {
    region = "ap-guangzhou"
    bucket = "terraform-state-1308378414"
    prefix = "yaml2infra/dev"
  }
}

provider "helm" {
    kubernetes {
        config_path = local_sensitive_file.kubeconfig.filename
    }
}

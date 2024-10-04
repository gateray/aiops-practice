provider "tencentcloud" {
    region = var.region
    secret_id = var.secret_id
    secret_key = var.secret_key
}

# Get availability zones
data "tencentcloud_availability_zones_by_product" "default" {
    product = "cvm"
    name = var.az
}

# Get availability images
data "tencentcloud_images" "default" {
  image_type = ["PUBLIC_IMAGE"]
  os_name    = "ubuntu"
}

# Get availability instance types
data "tencentcloud_instance_types" "default" {
  cpu_core_count = 2
  memory_size    = 4
  exclude_sold_out = true
  filter {
    name = "instance-charge-type"
    values = ["SPOTPAID"]  # 竞价实例
  }
}

# Create a web server
resource "tencentcloud_instance" "docker" {
  instance_name              = "docker"
  availability_zone          = data.tencentcloud_availability_zones_by_product.default.zones.0.name
  image_id                   = data.tencentcloud_images.default.images.0.image_id
  instance_type              = data.tencentcloud_instance_types.default.instance_types.0.instance_type
  system_disk_type           = "CLOUD_BSSD"
  system_disk_size           = 50
  allocate_public_ip         = true
  internet_max_bandwidth_out = 20
  orderly_security_groups            = [tencentcloud_security_group.default.id]
  password = var.cvm_pwd
  count                      = 1

  user_data = var.user_data != "" ? base64encode(file(var.user_data)) : ""
}

# Create security group
resource "tencentcloud_security_group" "default" {
  name        = "web accessibility"
  description = "make it accessible for both production and stage ports"
}

resource "tencentcloud_security_group_rule_set" "default" {
    security_group_id = tencentcloud_security_group.default.id
    ingress {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "80,443"
        description = "1:Allow web"
    }

    ingress {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "22"
        description = "2:Allow ssh"
    }

    ingress {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP"
        port        = "6443"
        description = "3:Allow k8s apiserver"
    }

    egress {
      action = "ACCEPT"
      cidr_block = "0.0.0.0/0"
      protocol = "ALL"
      port = "ALL"
      description = "Allow egress all"
    }    
}

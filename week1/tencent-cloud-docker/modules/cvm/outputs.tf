output "public_ip" {
    description = "cvm public ip address"
    value = tencentcloud_instance.docker[0].public_ip
}

output "private_ip" {
  description = "cvm private ip address"
  value = tencentcloud_instance.docker[0].private_ip
}
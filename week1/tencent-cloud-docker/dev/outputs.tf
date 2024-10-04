output "public_ip" {
    description = "cvm public ip address"
    value = module.cvm.public_ip
}

output "private_ip" {
  description = "cvm private ip address"
  value = module.cvm.private_ip
}


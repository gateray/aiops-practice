variable "cvm_user" {
    type = string
    description = "cvm login name"
}

variable "cvm_pwd" {
    type = string
    description = "cvm login password"
    sensitive = true
}

variable "public_ip" {}

variable "private_ip" {}
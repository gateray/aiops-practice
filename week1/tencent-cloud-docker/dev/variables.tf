variable "secret_id" {
    type = string
    description = "tencentcloud ak"
    sensitive = true
}

variable "secret_key" {
    type = string
    description = "tencentcloud sk"
    sensitive = true
}

variable "region" {
    type = string
    description = "region of cvm"
    default = "ap-singapore"
}

variable "az" {
    type = string
    description = "az of cvm"
    default = "ap-singapore-2"
}

variable "cvm_user" {
    type = string
    description = "cvm login name"
    default = "ubuntu"
}

variable "cvm_pwd" {
    type = string
    description = "cvm login password"
    sensitive = true
}

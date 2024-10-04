module "cvm" {
    source = "../modules/cvm"
    secret_id = var.secret_id
    secret_key = var.secret_key
    region = var.region
    az = var.az
    cvm_user = var.cvm_user
    cvm_pwd = var.cvm_pwd
    user_data = "${path.module}/install_docker.sh"
}

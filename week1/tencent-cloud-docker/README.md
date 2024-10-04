# 实践 Terraform，开通腾讯云虚拟机，并安装 Docker
## 说明
- 使用腾讯云cos对象存储作为terraform的backend
- 利用cvm资源的user_data参数，执行一个安装docker的shell脚本来实现docker安装

## 安装命令
```
export TF_VAR_secret_id=<AK>  # 腾讯云AK
export TF_VAR_secret_key=<SK> # 腾讯云SK
export TF_VAR_cvm_pwd=<ssh login password>   # cvm的ssh登陆密码

terraform init
terraform plan
terraform apply --auto-approve
```

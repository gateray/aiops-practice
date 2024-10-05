module "cvm" {
  source     = "../modules/cvm"
  secret_id  = var.secret_id
  secret_key = var.secret_key
  region     = var.region
  az         = var.az
  cvm_user   = var.cvm_user
  cvm_pwd    = var.cvm_pwd
}

module "k3s" {
  source     = "../modules/k3s"
  cvm_user   = var.cvm_user
  cvm_pwd    = var.cvm_pwd
  public_ip  = module.cvm.public_ip
  private_ip = module.cvm.private_ip
}

resource "local_sensitive_file" "kubeconfig" {
  content  = module.k3s.kube_config
  filename = "${path.module}/config.yaml"
}

resource "helm_release" "argocd" {
  depends_on       = [local_sensitive_file.kubeconfig, module.k3s]
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
}

resource "helm_release" "crossplane" {
  depends_on       = [local_sensitive_file.kubeconfig, module.k3s]
  name             = "crossplane"
  repository       = "https://charts.crossplane.io/stable"
  chart            = "crossplane"
  namespace        = "crossplane"
  create_namespace = true
}


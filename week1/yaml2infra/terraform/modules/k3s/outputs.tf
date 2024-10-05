output "kube_config" {
    description = "kubeconfig"
    value = module.k3s.kube_config
}

output "kubernetes" {
    value = module.k3s.kubernetes
}


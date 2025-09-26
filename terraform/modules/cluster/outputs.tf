output "kubeconfig_path" {
  value = "${path.module}/kubeconfig"
  description = "Arquivo kubeconfig baixado após criação do cluster"
}

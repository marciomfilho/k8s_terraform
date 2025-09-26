resource "helm_release" "argo" {
  name             = "argo"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = var.namespace
  version          = "5.43.4"
  create_namespace = true

  set = [
    {
      name  = "service.type"
      value = "LoadBalancer"
    }
  ]
}

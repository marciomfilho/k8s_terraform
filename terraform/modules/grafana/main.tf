resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = var.namespace
  version          = "6.46.2"
  create_namespace = true

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}

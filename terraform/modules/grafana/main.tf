provider "helm" {
  kubernetes = {
    config_path = "./kubeconfig"
  }
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = var.grafana_namespace
  version          = "6.43.1"
  create_namespace = true

  set = [
    {
      name  = "service.type"
      value = "LoadBalancer"
    },
    {
      name  = "adminUser"
      value = "admin"
    },
    {
      name  = "adminPassword"
      value = "secure_password"
    }
  ]
}

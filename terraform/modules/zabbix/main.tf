resource "helm_release" "zabbix" {
  name             = "zabbix"
  repository       = "https://zabbix.github.io/helm-charts/"
  chart            = "zabbix-server"
  namespace        = var.namespace
  version          = "2.0.0"
  create_namespace = true

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}

resource "helm_release" "zabbix" {
  name             = "zabbix"
  repository       = "https://zabbix-community.github.io/helm-zabbix"
  chart            = "helm-zabbix"
  namespace        = var.namespace
  version          = "0.15.0"
  create_namespace = true

  set = [
    {
      name  = "service.type"
      value = "LoadBalancer"
    },
    {
      name  = "zabbixServer.adminPassword"
      value = "secure_password"
    }
  ]
}

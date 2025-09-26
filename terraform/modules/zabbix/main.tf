resource "helm_release" "zabbix" {
  name             = "zabbix"
  repository       = "https://zabbix-community.github.io/zabbix"
  chart            = "zabbix"
  namespace        = var.namespace
  version          = "7.0.12"
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
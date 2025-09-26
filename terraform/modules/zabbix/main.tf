provider "helm" {
  kubernetes = {
    config_path = "./kubeconfig"
  }
}

resource "helm_release" "zabbix" {
  name             = "zabbix"
  repository       = "https://zabbix.github.io/zabbix-helm/"
  chart            = "zabbix"
  namespace        = var.zabbix_namespace
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

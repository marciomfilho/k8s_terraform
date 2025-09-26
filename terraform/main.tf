module "cluster" {
  source = "./modules/cluster"
  host = var.host
  user = var.user
  private_key_path = var.private_key_path
}

module "zabbix" {
  source    = "./modules/zabbix"
  namespace = "monitoring"
  depends_on = [module.cluster]
}

module "grafana" {
  source    = "./modules/grafana"
  namespace = "monitoring"
  depends_on = [module.cluster]
}

module "argo" {
  source    = "./modules/argo"
  namespace = "monitoring"
  depends_on = [module.cluster]
}

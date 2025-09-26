provider "helm" {
  alias = "root_helm"
  kubernetes = {
    config_path = "./kubeconfig"
  }
}

module "cluster" {
  source = "./modules/cluster"
}

module "argo" {
  source = "./modules/argo"
  namespace = "argo"

  providers = {
    helm = helm.root_helm
  }

  depends_on = [module.cluster]
}

module "grafana" {
  source = "./modules/grafana"
  namespace = "grafana"

  providers = {
    helm = helm.root_helm
  }

  depends_on = [module.cluster]
}

module "zabbix" {
  source = "./modules/zabbix"
  namespace = "zabbix"

  providers = {
    helm = helm.root_helm
  }

  depends_on = [module.cluster]
}

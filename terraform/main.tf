provider "helm" {
  alias = "root_helm"
  kubernetes = {
    config_path = "./kubeconfig"
  }
}

module "cluster" {
  source          = "./modules/cluster"
  host            = "192.168.15.158"
  user            = "marcio"
  private_key_path = "/Users/marcio/.ssh/id_rsa"
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

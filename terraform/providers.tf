provider "null" {}

provider "ssh" {
  host        = var.host
  user        = var.user
  private_key = file(var.private_key_path)
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

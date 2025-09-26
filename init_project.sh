#!/bin/bash
set -e

BASE_DIR="terraform"
MODULES_DIR="$BASE_DIR/modules"

mkdir -p "$MODULES_DIR/cluster"
mkdir -p "$MODULES_DIR/zabbix"
mkdir -p "$MODULES_DIR/grafana"
mkdir -p "$MODULES_DIR/argo"

# providers.tf
cat > "$BASE_DIR/providers.tf" <<EOF
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
EOF

# variables.tf
cat > "$BASE_DIR/variables.tf" <<EOF
variable "host" {
  description = "IP do servidor Ubuntu"
  type        = string
  default     = "192.168.15.158"
}

variable "user" {
  description = "Usuário SSH do servidor"
  type        = string
  default     = "ubuntu"
}

variable "private_key_path" {
  description = "Caminho para chave privada SSH"
  type        = string
  default     = "~/.ssh/id_rsa"
}
EOF

# outputs.tf
cat > "$BASE_DIR/outputs.tf" <<EOF
output "zabbix_status" {
  value = module.zabbix.zabbix_status
}

output "grafana_status" {
  value = module.grafana.grafana_status
}

output "argo_status" {
  value = module.argo.argo_status
}
EOF

# main.tf
cat > "$BASE_DIR/main.tf" <<EOF
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
EOF

# modules/cluster/main.tf
cat > "$MODULES_DIR/cluster/main.tf" <<EOF
resource "null_resource" "setup_k8s_master" {
  connection {
    type        = "ssh"
    host        = var.host
    user        = var.user
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable\"",
      "sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
      "sudo systemctl enable docker.service",
      "sudo systemctl start docker.service",
      "sudo swapoff -a",
      "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
      "sudo apt-add-repository \"deb http://apt.kubernetes.io/ kubernetes-xenial main\"",
      "sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl",
      "sudo kubeadm init --pod-network-cidr=10.244.0.0/16",
      "mkdir -p /home/\${var.user}/.kube",
      "sudo cp -i /etc/kubernetes/admin.conf /home/\${var.user}/.kube/config",
      "sudo chown \${var.user}:\${var.user} /home/\${var.user}/.kube/config",
      "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"
    ]
  }
}
EOF

# modules/cluster/variables.tf
cat > "$MODULES_DIR/cluster/variables.tf" <<EOF
variable "host" {
  description = "IP do servidor Ubuntu"
  type        = string
}

variable "user" {
  description = "Usuário SSH"
  type        = string
}

variable "private_key_path" {
  description = "Caminho local para chave SSH"
  type        = string
}
EOF

echo "Estrutura inicial do projeto Terraform criada com sucesso!"


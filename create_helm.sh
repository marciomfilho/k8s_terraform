#!/bin/bash
set -e

BASE_DIR="terraform"
MODULES_DIR="$BASE_DIR/modules"

# Função para criar módulo Helm
create_helm_module() {
  local name=$1
  local repo=$2
  local chart=$3
  local version=$4

  local dir="$MODULES_DIR/$name"
  mkdir -p "$dir"

  cat > "$dir/main.tf" <<EOF
resource "helm_release" "$name" {
  name             = "$name"
  repository       = "$repo"
  chart            = "$chart"
  namespace        = var.namespace
  version          = "$version"
  create_namespace = true

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}
EOF

  cat > "$dir/variables.tf" <<EOF
variable "namespace" {
  description = "Namespace Kubernetes para o módulo $name"
  type        = string
  default     = "monitoring"
}
EOF

  cat > "$dir/outputs.tf" <<EOF
output "${name}_status" {
  value = helm_release.$name.status
}
EOF

  echo "Módulo Helm $name criado."
}

create_helm_module zabbix "https://zabbix.github.io/helm-charts/" "zabbix-server" "2.0.0"
create_helm_module grafana "https://grafana.github.io/helm-charts" "grafana" "6.46.2"
create_helm_module argo "https://argoproj.github.io/argo-helm" "argo-cd" "5.43.4"

echo "Módulos Helm criados com sucesso!"


output "zabbix_status" {
  value = module.zabbix.zabbix_status
}

output "grafana_status" {
  value = module.grafana.grafana_status
}

output "argo_status" {
  value = module.argo.argo_status
}

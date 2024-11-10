output "cluster_name" {
  value = module.gke.cluster_name
}

output "cluster_endpoint" {
  value = module.gke.cluster_endpoint
}

output "database_instance" {
  value = module.sql.database_instance
}

output "database_private_ip" {
  value = module.sql.database_private_ip
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_id" {
  value = google_container_cluster.primary.id
}

output "node_id" {
  value = google_container_node_pool.primary_nodes.id
}
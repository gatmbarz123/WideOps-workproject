output "network_id" {
  value = google_compute_network.vpc.id
}

output "subnet_name_public" {
  value = google_compute_subnetwork.subnet-public.name
}


output "network_name" {
  value = google_compute_network.vpc.name
}

output "subnet_name" {
  value = google_compute_subnetwork.subnet.name
}
output "database_instance" {
  value = google_sql_database_instance.wordpress.name
}

output "database_private_ip" {
  value = google_sql_database_instance.wordpress.private_ip_address
}

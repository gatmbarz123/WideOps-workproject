resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "wordpress" {
  name             = "wordpress-mysql"
  database_version = "MYSQL_8_0"
  region           = var.region

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }
  }

  deletion_protection = false 

  lifecycle {
    prevent_destroy = false
  }


}

resource "google_sql_database" "wordpress" {
  name     = var.db_name
  instance = google_sql_database_instance.wordpress.name
}

resource "google_sql_user" "wordpress" {
  name     = var.db_user
  instance = google_sql_database_instance.wordpress.name
  password = var.db_password
}
resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network_id
  depends_on = [var.network_id]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_sql_database_instance" "wordpress" {
  name             = "wordpress-mysql"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }
  }
  depends_on=[google_service_networking_connection.private_vpc_connection]
  deletion_protection = false 

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

#------------------------------------------------------------------------PRIVATE

#------------------------------------------------------------------------PUBLIC

resource "google_compute_instance" "bastion" {
  name         = "bastion-host"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network    =var.network_id    
    subnetwork = var.public_subnet

    access_config {
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y mysql-client
  EOF

}
variable "network_id" {
  description = "VPC Network ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "db_name" {
  description = "WordPress Database Name"
  type        = string
}

variable "db_user" {
  description = "Database User"
  type        = string
}

variable "db_password" {
  description = "Database Password"
  type        = string
}

variable "gke_id" {
  description = "Cluster ID"
  type        = string
}

variable "node_id" {
  description = "Node ID"
  type        = string
}

variable "public_subnet"{
  description = "Public Subnet for bastion host"
  type        = string
}
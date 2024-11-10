variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "GKE Cluster Name"
  type        = string
  default     = "wordpress-cluster"
}

variable "db_name" {
  description = "WordPress Database Name"
  type        = string
  default     = "wordpress"
}

variable "db_user" {
  description = "Database User"
  type        = string
  default     = "wordpress"
}

variable "db_password" {
  description = "Database Password"
  type        = string
  sensitive   = true
}

variable "sa" {
  description = "Service Account"
  type        = string
  sensitive   = true
}
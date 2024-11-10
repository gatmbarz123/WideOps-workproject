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
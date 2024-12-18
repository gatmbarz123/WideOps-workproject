terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
  backend "gcs" {
    bucket = "vpc-peering-bar-project"
    prefix = "tfstate.json"
  }

  required_version = "~> 1.7, < 2.0"
}


provider "google" {
  credentials = file(var.sa)
  project     = var.project_id
  region      = var.region
  
}

#------------------------------------------------------------------------PROVIDER

#------------------------------------------------------------------------MODULES


module "vpc" {
  source = "./modules/vpc"
  region = var.region
}

module "gke" {
  source = "./modules/gke"
  
  cluster_name = var.cluster_name
  zone        = var.zone
  network_name = module.vpc.network_name
  subnet_name  = module.vpc.subnet_name
}

module "sql" {
  source = "./modules/sql"
  
  network_id   = module.vpc.network_id
  region       = var.region
  db_name      = var.db_name
  db_user      = var.db_user
  db_password  = var.db_password
  gke_id      = module.gke.cluster_id
  node_id     =module.gke.node_id
  public_subnet=module.vpc.subnet_name_public

}
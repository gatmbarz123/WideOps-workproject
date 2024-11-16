# Google Cloud Infrastructure Setup with Kubernetes, GKE, and CloudSQL

## Project Overview

This project involves designing and deploying a **scalable** and **secure** cloud infrastructure on **Google Cloud Platform (GCP)** using key services like **Google Kubernetes Engine (GKE)**, **CloudSQL**, and **WordPress**. The goal is to create a secure environment that supports automatic scaling and is managed efficiently through **Terraform**. By leveraging **Kubernetes** for containerized application management, I was able to gain hands-on experience with **GCP services** and deploy a production-ready WordPress application.

---

#### Tools & Technologies

- **Google Kubernetes Engine (GKE)**
- **CloudSQL (MySQL)**
- **WordPress (Deployment)**
- **Terraform (Infrastructure Automation)**
- **Docker (Local Development)**
- **MySQL (Database for WordPress)**
- **Kubernetes YAML Configurations**
- **Nginx Ingress Controller (via Helm)**

---

#### Infrastructure Overview
   ```
   ├── k8s/                        
   │
   ├── tf/                         
   │   ├── main.tf                 
   │   ├── variables.tf            
   │   ├── locals.tf           
   │   ├── outpus.tf 
   │   ├── var.tfvars 
   │   ├── modules/
   │   │   ├──gke/                 
   │   │   │   ├── main.tf  # GKE Cluster         
   │   │   │   ├── variables.tf    
   │   │   │   ├── outputs.tf      
   │   │   │   └── data.tf 
   │   │   ├── sql/             
   │   │   │   ├── main.tf  # CLoudSQL MYSQL   
   │   │   │   ├── variables.tf     
   │   │   │   ├── outputs.tf       
   │   │   │   └── data-.tf  
   │   │   ├── vpc/           
   │   │   │   ├── main.tf  # VPC, private subnets, NAT Gateway      
   │   │   │   ├── variables.tf    
   │   │   │   ├── outputs.tf       
   │   │   │   └── data-sources.tf  

 ```
    
### 1. **VPC and Subnet Configuration**
To ensure complete isolation of the infrastructure, I created a **private VPC** with dedicated subnets for **GKE** and **CloudSQL**. This setup ensures that all communication between services happens within a private network, protecting the infrastructure from public access.

- **Private VPC** for secure internal communication.
- **Dedicated subnets** for GKE and CloudSQL.

### 2. **Firewall Rules**
Tight **firewall rules** were set up to restrict traffic. Only authorized IP addresses are allowed to interact with the infrastructure, ensuring a secure environment.

### 3. **CloudSQL Setup**
I deployed **CloudSQL** (MySQL) with **private connectivity** to eliminate external access. The connection between **CloudSQL** and **GKE** was managed via **service networking**, ensuring secure communication within the private network.

- **Service Networking** for secure connectivity.
- **CloudSQL (MySQL)** for WordPress database.

### 4. **GKE Cluster Setup**
A **private GKE cluster** was set up to run the containerized WordPress application. Key security features include:
- **Private nodes** with no internet access.
- **Private Kubernetes control plane** to prevent external exposure.

### 5. **Horizontal Pod Autoscaling and Ingress Configuration**
To enable dynamic scaling, I implemented **Horizontal Pod Autoscaling (HPA)** to adjust the number of pods based on CPU usage. Additionally, I configured an **Ingress Controller** using **Nginx** to manage incoming **HTTP/HTTPS traffic** to the application.

- **HPA** for automatic scaling based on CPU usage.
- **Nginx Ingress Controller** for external access via `bagum.shop`.

---

## Kubernetes Setup
```
├── k8s/                                                
│   ├── horizontal.yml                
│   ├── ingress.yml          
│   ├── nginx-values.yml          
│   ├── wordpress-pvc.yml
│   ├── wordpress-secrets.yml
│   ├── wordpress.yml

```

### 1. **Persistent Volume Claim (PVC)**
```
NAME                STATUS    VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   
wordpress-pvc-new   Bound     pvc-8684a76e-9a6e-46c3-b309-fefd2b4d058f   10Gi       RWO            standard-rwo   <unset>                 
```
**PVCs** were used to request persistent storage for WordPress, ensuring that data (posts, media files) persists across pod restarts.

### 2. **Secrets Management**
Sensitive data such as database credentials and environment variables were securely stored using **Kubernetes Secrets**, ensuring no sensitive data is exposed.

### 3. **Services **
```
NAME         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          
kubernetes   ClusterIP   10.2.0.1      <none>        443/TCP          
wordpress    ClusterIP   10.2.110.58   <none>        80/TCP,443/TCP
```
A **ClusterIP Service** was created to expose the WordPress application to the outside world. The service routes traffic to healthy pods, and **health checks** ensure only healthy instances are targeted.

### 4. **Deployment Configuration**
```
NAME                         READY   STATUS    RESTARTS   
wordpress-5c8557978c-8z2dj   1/1     Running   0
```
The **Deployment YAML** file includes the configuration for both **WordPress** and **MySQL** containers, covering:
- **Volume mounts** for persistent storage.
- **Resource requests and limits** for optimal pod scaling.

---

## 5. **Ingress and Nginx Configuration**

Once the pods were set up to receive **HTTP/HTTPS traffic**, I configured the **Nginx Ingress Controller** using **Helm**. The **Ingress** efficiently routes incoming traffic to WordPress via the domain `bagum.shop`.
```
NAME                CLASS            HOSTS            ADDRESS        PORTS   
wordpress-ingress   external-nginx   bar.bagum.shop   34.57.12.123   80
```
- **Nginx Ingress Controller** for routing traffic.
- **Domain**: `bagum.shop`.

---

## 6. **Auto-Scaling with HorizontalPodAutoscaler**

To handle fluctuating traffic, I implemented **HorizontalPodAutoscaler (HPA)** to adjust the number of pods based on CPU usage. The HPA ensures that the application can scale efficiently during high traffic periods, while scaling down when demand decreases.

- **HPA** triggered at **70% CPU usage** threshold.

---

## **Local Development and WordPress Setup**

Before deploying to **GKE**, I used **Docker Compose** to set up WordPress locally, running both the **WordPress** and **MySQL** containers on my local machine. This ensured proper functionality before migrating to Kubernetes.

---

## **Troubleshooting and Challenges**

During the setup, I encountered several challenges that helped me refine my approach:

### 1. **Network Connectivity Issues**
Configuring **VPC Peering** and ensuring secure communication between **CloudSQL** and the **GKE cluster** required fine-tuning firewall rules and service networking settings.

### 2. **Ingress Controller Setup**
Configuring the **Nginx Ingress Controller** to handle traffic routing and link it correctly to the domain `bagum.shop` required multiple iterations and adjustments to the Ingress and DNS settings.

### 3. **Persistent Volumes Claim Configuration**
Setting up **Persistent Volumes Claim (PVCs)** and ensuring data persistence across pod restarts was tricky, requiring debugging of PVCs and ensuring proper All the information is synchronized with everyone.

### 4. **Pod Autoscaling Issues**
The **HorizontalPodAutoscaler** didn’t scale pods as expected initially. Troubleshooting involved checking resource requests, limits, CPU metrics, and ensuring the **metrics server** was correctly configured.

These challenges were valuable learning experiences and helped deepen my understanding of **GCP**, **Kubernetes**, and **cloud infrastructure management**.

---
![WebSite Photos](Photo/web1.png)

---
![More Photos](Photo/web2.png)

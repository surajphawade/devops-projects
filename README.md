# Deploy Java Application on Azure 3-Tier Architecture

![Azure Architecture](https://imgur.com/b9iHwVc.png)

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture Overview](#architecture-overview)
3. [Pre-Requisites](#pre-requisites)
4. [Infrastructure Setup](#infrastructure-setup)

   * [Virtual Network and Networking](#virtual-network-and-networking)
   * [Security Configuration](#security-configuration)
   * [Database Layer](#database-layer)
5. [Application Setup](#application-setup)

   * [Build Environment](#build-environment)
   * [Application Deployment](#application-deployment)
   * [Load Balancing and Auto Scaling](#load-balancing-and-auto-scaling)
6. [Monitoring and Maintenance](#monitoring-and-maintenance)
7. [Security Best Practices](#security-best-practices)
8. [Troubleshooting Guide](#troubleshooting-guide)
9. [Contributing](#contributing)

---

![3-tier Architecture Diagram](https://imgur.com/3XF0tlJ.png)

---

# Project Overview

## Introduction

This project demonstrates the deployment of a production-grade Java web application using Azure's robust 3-tier architecture. The implementation follows cloud-native best practices, ensuring high availability, scalability, and security across all application tiers.

### Key Features

* **High Availability**: Multi-Zone deployment with automated failover
* **Auto Scaling**: Dynamic resource allocation based on demand
* **Security**: Defense-in-depth approach with multiple security layers
* **Monitoring**: Comprehensive logging and monitoring setup
* **Cost Optimization**: Efficient resource utilization and management

## Architecture Overview

### Infrastructure Components

1. **Presentation Tier (Frontend)**

   * Nginx web servers in Virtual Machine Scale Set (VMSS)
   * Public Azure Load Balancer
   * Azure CDN for static content

2. **Application Tier (Backend)**

   * Apache Tomcat servers in Virtual Machine Scale Set (VMSS)
   * Internal Azure Load Balancer
   * Session management with Azure Cache for Redis

3. **Data Tier**

   * Azure Database for MySQL Flexible Server
   * Automated backups and point-in-time recovery
   * Read replicas for read-heavy workloads

### Network Architecture

* **Virtual Network Design**

  * Two separate VNets (192.168.0.0/16 and 172.32.0.0/16)
  * Public and private subnets across multiple Availability Zones
  * VNet Peering for inter-VNet communication

# Pre-Requisites

## Required Accounts and Tools

### 1. Azure Account Setup

* Create an [Azure Free Account](https://azure.microsoft.com/free/)
* Install Azure CLI

  ```bash
  # For Linux
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

  # For macOS
  brew update && brew install azure-cli

  # Login to Azure
  az login
  ```

### 2. Development Tools

* **Git**: Version control system

  ```bash
  # For Linux
  sudo apt-get update
  sudo apt-get install git

  # For macOS
  brew install git
  ```

### 3. CI/CD Integration

* **SonarCloud Account**

  * Sign up at [SonarCloud](https://sonarcloud.io/)
  * Generate authentication token
  * Configure project settings:

    ```bash
    # Add to pom.xml
    <properties>
        <sonar.projectKey>your_project_key</sonar.projectKey>
        <sonar.organization>your_organization</sonar.organization>
        <sonar.host.url>https://sonarcloud.io</sonar.host.url>
    </properties>
    ```

* **Azure Artifacts**

  * Create Azure DevOps organization
  * Set up Maven feed
  * Configure authentication:

    ```xml
    <!-- settings.xml -->
    <servers>
        <server>
            <id>azure-artifacts</id>
            <username>AzureDevOps</username>
            <password>${env.AZURE_DEVOPS_PAT}</password>
        </server>
    </servers>
    ```

# Infrastructure Setup

## Virtual Network and Networking

### 1. Resource Group Creation

```bash
az group create \
    --name JavaApp-RG \
    --location eastus
```

### 2. Virtual Network Creation

```bash
# Create primary VNet
az network vnet create \
    --resource-group JavaApp-RG \
    --name PrimaryVNet \
    --address-prefix 192.168.0.0/16 \
    --subnet-name PublicSubnet \
    --subnet-prefix 192.168.1.0/24

# Create secondary VNet
az network vnet create \
    --resource-group JavaApp-RG \
    --name SecondaryVNet \
    --address-prefix 172.32.0.0/16 \
    --subnet-name PrivateSubnet \
    --subnet-prefix 172.32.1.0/24
```

### 3. Additional Subnets

```bash
# Create application subnet
az network vnet subnet create \
    --resource-group JavaApp-RG \
    --vnet-name PrimaryVNet \
    --name AppSubnet \
    --address-prefixes 192.168.2.0/24

# Create database subnet
az network vnet subnet create \
    --resource-group JavaApp-RG \
    --vnet-name PrimaryVNet \
    --name DBSubnet \
    --address-prefixes 192.168.3.0/24
```

### 4. VNet Peering

```bash
# Peer VNets
az network vnet peering create \
    --name PrimaryToSecondary \
    --resource-group JavaApp-RG \
    --vnet-name PrimaryVNet \
    --remote-vnet SecondaryVNet \
    --allow-vnet-access
```

## Security Configuration

### 1. Network Security Groups

```bash
# Create frontend NSG
az network nsg create \
    --resource-group JavaApp-RG \
    --name FrontendNSG

# Allow HTTP traffic
az network nsg rule create \
    --resource-group JavaApp-RG \
    --nsg-name FrontendNSG \
    --name AllowHTTP \
    --protocol Tcp \
    --priority 100 \
    --destination-port-range 80 \
    --access Allow

# Allow HTTPS traffic
az network nsg rule create \
    --resource-group JavaApp-RG \
    --nsg-name FrontendNSG \
    --name AllowHTTPS \
    --protocol Tcp \
    --priority 110 \
    --destination-port-range 443 \
    --access Allow
```

### 2. Managed Identity and RBAC

```bash
# Create managed identity
az identity create \
    --resource-group JavaApp-RG \
    --name JavaAppIdentity

# Assign Storage Blob Data Contributor role
az role assignment create \
    --assignee <principal-id> \
    --role "Storage Blob Data Contributor" \
    --scope /subscriptions/<subscription-id>/resourceGroups/JavaApp-RG
```

## Database Layer

### 1. Azure Database for MySQL Creation

```bash
az mysql flexible-server create \
    --resource-group JavaApp-RG \
    --name prod-mysql \
    --location eastus \
    --admin-user adminuser \
    --admin-password "YourSecurePassword123!" \
    --sku-name Standard_B2s \
    --tier Burstable \
    --storage-size 20 \
    --version 8.0
```

### 2. Database Initialization

```sql
-- Connect to database
mysql -h your-mysql-server.mysql.database.azure.com -u adminuser -p

-- Create application database
CREATE DATABASE javaapp;
USE javaapp;

-- Create users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create necessary indexes
CREATE INDEX idx_username ON users(username);
CREATE INDEX idx_email ON users(email);
```

# Application Setup

## Build Environment

### 1. Maven Configuration

```xml
<!-- pom.xml -->
<project>
    <properties>
        <java.version>11</java.version>
        <spring.version>2.5.12</spring.version>
    </properties>

    <dependencies>
        <!-- Add your dependencies here -->
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

### 2. Build Process

```bash
# Clean and build project
mvn clean package -DskipTests

# Run tests
mvn test

# Deploy to Azure Artifacts
mvn deploy
```

## Application Deployment

### 1. Tomcat Configuration

```bash
# Create tomcat.service
sudo tee /etc/systemd/system/tomcat.service << EOF
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking
Environment=JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF
```

### 2. Nginx Configuration

```nginx
# /etc/nginx/conf.d/app.conf
upstream backend {
    server internal-loadbalancer:8080;
}

server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /static/ {
        proxy_pass https://your-cdn-endpoint.azureedge.net;
    }
}
```

## Load Balancing and Auto Scaling

### 1. Virtual Machine Scale Set Creation

```bash
az vmss create \
    --resource-group JavaApp-RG \
    --name WebServerVMSS \
    --image Ubuntu2204 \
    --instance-count 2 \
    --vm-sku Standard_B2s \
    --admin-username azureuser \
    --generate-ssh-keys \
    --load-balancer WebLB \
    --vnet-name PrimaryVNet \
    --subnet PublicSubnet
```

### 2. Auto Scaling Configuration

```bash
az monitor autoscale create \
    --resource-group JavaApp-RG \
    --resource WebServerVMSS \
    --resource-type Microsoft.Compute/virtualMachineScaleSets \
    --name WebServerAutoscale \
    --min-count 2 \
    --max-count 6 \
    --count 2
```

# Monitoring and Maintenance

## Azure Monitor Setup

### 1. Metrics Configuration

```bash
# Install Azure Monitor agent
az vm extension set \
    --resource-group JavaApp-RG \
    --vm-name vm-name \
    --name AzureMonitorLinuxAgent \
    --publisher Microsoft.Azure.Monitor
```

### 2. Log Analytics Workspace

```bash
# Create Log Analytics workspace
az monitor log-analytics workspace create \
    --resource-group JavaApp-RG \
    --workspace-name JavaAppLogs \
    --location eastus
```

### 3. Diagnostic Settings

```bash
az monitor diagnostic-settings create \
    --resource /subscriptions/<subscription-id>/resourceGroups/JavaApp-RG/providers/Microsoft.Compute/virtualMachineScaleSets/WebServerVMSS \
    --name VMSSDiagnostics \
    --workspace JavaAppLogs \
    --logs '[{"category":"Administrative","enabled":true}]' \
    --metrics '[{"category":"AllMetrics","enabled":true}]'
```

# Security Best Practices

## 1. Network Security

* Implement Network Security Groups (NSGs)
* Use Azure Firewall
* Enable NSG Flow Logs
* Configure Azure DDoS Protection

## 2. Application Security

* Regular security patches
* Implement Microsoft Defender for Cloud
* Use Azure Key Vault
* Enable Microsoft Sentinel

## 3. Data Security

* Enable encryption at rest
* Use SSL/TLS for data in transit
* Regular security audits
* Implement backup strategies

# Troubleshooting Guide

## Common Issues and Solutions

### 1. Connection Issues

```bash
# Check connectivity
telnet mysql-server.mysql.database.azure.com 3306

# Verify NSG rules
az network nsg rule list \
    --resource-group JavaApp-RG \
    --nsg-name FrontendNSG

# Check VMSS instances
az vmss list-instances \
    --resource-group JavaApp-RG \
    --name WebServerVMSS
```

### 2. Performance Issues

```bash
# Check CPU usage
top -bn1

# Monitor memory usage
free -m

# Check disk usage
df -h

# Monitor Tomcat threads
ps -eLf | grep java | wc -l
```

# Contributing

## How to Contribute

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Development Setup

```bash
# Clone repository
git clone https://github.com/yourusername/your-repo.git

# Install dependencies
mvn install

# Run tests
mvn test
```

---

## 🛠️ Author & Community

This project is maintained by **[Harshhaa](https://github.com/NotHarshhaa)** 💡.
Your feedback and contributions are welcome!

📧 **Connect with me:**

* **GitHub**: [@NotHarshhaa](https://github.com/NotHarshhaa)
* **Blog**: [ProDevOpsGuy](https://blog.prodevopsguytech.com)
* **Telegram Community**: [Join Here](https://t.me/prodevopsguy)
* **LinkedIn**: [Harshhaa Vardhan Reddy](https://www.linkedin.com/in/harshhaa-vardhan-reddy/)

---

## ⭐ Support the Project

If you found this project helpful, please consider:

* **Starring** ⭐ the repository
* **Sharing** it with your network
* **Contributing** to its improvement

### 📢 Stay Connected

![Follow Me](https://imgur.com/2j7GSPs.png)

> [!Important]
> This documentation is continuously evolving. For the latest updates, please check the repository regularly.

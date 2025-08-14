# BetterMe DevOps test – Infrastructure (WIP)

⚠ **Status:** Work In Progress (WIP)  
This project is still under active development.  
Terraform `apply` for the AWS infrastructure takes **30+ minutes** for each change which makes rapid testing slow.  
The current state is **not fully tested** – all components are drafts for illustration purposes.


![the example of terraform apply](./images/screenshot.png)


## Overview

This infrastructure deploys:
- **VPC** with public and private subnets
- **Amazon EKS** cluster (private subnets)
- **RDS PostgreSQL** instance (`db.t3.micro`)
- **Two S3 buckets**:
  - **Public** bucket for publicly accessible data over HTTPS
  - **Private** bucket accessible only from within the VPC
- **AWS Secrets Manager** for database and AWS credentials
- Application deployed via **Helm** chart

The application:
- Runs a Node.js service from:


```mermaid
graph TD
    subgraph AWS
        subgraph VPC
            direction TB
            PublicSubnets[Public Subnets]
            PrivateSubnets[Private Subnets]

            EKSCluster[EKS Cluster]
            RDS[(RDS PostgreSQL)]
            S3Public[(Public S3 Bucket)]
            S3Private[(Private S3 Bucket)]
        end
    end

    User[User] -->|HTTPS| EKSCluster
    EKSCluster -->|connects| RDS
    EKSCluster -->|reads/writes| S3Public
    EKSCluster -->|reads/writes| S3Private

    SecretsManager[AWS Secrets Manager] -->|mount via CSI/IRSA| EKSCluster


```
# Terraform Static Website Hosting on AWS

This project demonstrates how to deploy a secure static website on AWS using Terraform Infrastructure as Code (IaC).

The website is hosted using:

* Amazon S3
* Amazon CloudFront
* Origin Access Control (OAC)
* Terraform

## Project Architecture

Users → CloudFront → Private S3 Bucket

CloudFront securely accesses the private S3 bucket using Origin Access Control (OAC), following production-level best practices.

---

# Technologies Used

* Terraform
* AWS S3
* AWS CloudFront
* IAM Policies
* Origin Access Control (OAC)

---

# Features

* Static website hosting
* Private S3 bucket
* CloudFront CDN integration
* Secure access using OAC
* Automated file uploads using Terraform
* Infrastructure as Code (IaC)

---

# Terraform Concepts Used

* Variables
* Locals
* Outputs
* Resource Dependencies
* for_each
* fileset()
* jsonencode()

---

# Folder Structure

```bash
terraform/
│
├── WEB/
│   ├── index.html
│   ├── style.css
│   └── script.js
│
├── img/
│   ├── aws-console.png
│   └── output-img.png
│
├── main.tf
├── variables.tf
├── outputs.tf
├── .gitignore
└── README.md
```

---

# Deployment Steps

## Initialize Terraform

```bash
terraform init
```

## Validate Configuration

```bash
terraform validate
```

## Preview Infrastructure

```bash
terraform plan
```

## Deploy Infrastructure

```bash
terraform apply
```

---

# Destroy Infrastructure

To remove all AWS resources:

```bash
terraform destroy
```

---

# Website URL

```text
d28fl4r93tms5o.cloudfront.net
```

---

# Screenshots

## AWS Console

![AWS Console](terraform/img/aws-console.png)

## Website Output

![Website Output](terraform/img/output-img.png)

---

# Learning Outcomes

Through this project, I learned:

* How CloudFront CDN works
* Difference between public and private S3 buckets
* Secure static hosting architecture
* AWS bucket policies
* Terraform state and lock files
* Debugging Terraform errors
* Infrastructure automation using Terraform

---

# Author

Anjali Kumari Prasad


#!/bin/bash
# ---- Configuration variables ----

# Change these as needed
PROJECT_ID="your-gcp-project-id"
REGION="europe-central2"
ZONE="europe-central2-a"
VPC_NAME="petclinic-vpc-toma"
SUBNET_NAME="petclinic-subnet-toma"
VM_NAME="petclinic-vm-toma"
FIREWALL_NAME="petclinic-fw-toma"
SSH_NAME="allow-sh-t"
IMAGE_NAME="spring-petclinic-toma"
GCR_IMAGE="gcr.io/$PROJECT_ID/$IMAGE_NAME"
DOCKERHUB_IMAGE="tomaciobotaru12/spring-petclinic-main:latest"
TAG="v1"


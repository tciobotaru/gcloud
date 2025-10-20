#!/bin/bash
# ---- Configuration variables ----

# Change these as needed
PROJECT_ID="gd-gcp-internship-devops"
REGION="europe-central2"
ZONE="europe-central2-a"
VPC_NAME="petclinic-vpc-toma"
SUBNET_NAME="petclinic-subnet-toma"
VM_NAME="petclinic-vm-toma"
FIREWALL_NAME="petclinic-fw-toma"
SSH_NAME="allow-sh-t"
IMAGE_NAME="spring-petclinic-toma"
GCR_IMAGE="gcr.io/$PROJECT_ID/$IMAGE_NAME"
DOCKERHUB_IMAGE="tomaciobotaru12/spring-petclinic-main:a35aae3"
AR_REPO_NAME="spring-petclinic-toma"
TAG="v1"


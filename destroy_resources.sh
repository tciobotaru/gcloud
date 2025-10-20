#!/bin/bash
set -e
source vars.sh

echo "[1/5] Deleting VM..."
gcloud compute instances delete $VM_NAME --zone=$ZONE --quiet || echo "VM not found."

echo "[2/5] Deleting Firewall Rule for HTTP..."
gcloud compute firewall-rules delete $FIREWALL_NAME --quiet || echo "Firewall rule $FIREWALL_NAME not found."

echo "[3/5] Deleting Firewall Rule for SSH..."
gcloud compute firewall-rules delete $SSH_NAME --quiet || echo "Firewall rule $SSH_NAME not found."

echo "[4/5] Deleting Subnet..."
gcloud compute networks subnets delete $SUBNET_NAME --region=$REGION --quiet || echo "Subnet not found."

echo "[5/5] Deleting VPC..."
gcloud compute networks delete $VPC_NAME --quiet || echo "VPC not found."

echo " Deleting Artifact Registry repository..."
gcloud artifacts repositories delete $AR_REPO_NAME --location=$REGION --quiet || echo "Artifact Registry repo not found."


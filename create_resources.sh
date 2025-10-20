#!/bin/bash
set -e
source vars.sh

echo ">>> Enabling required APIs..."
gcloud services enable compute.googleapis.com artifactregistry.googleapis.com

# === Step 1: Create VPC and Subnet ===
echo ">>> Creating VPC and Subnet..."
gcloud compute networks create $VPC_NAME --subnet-mode=custom || echo "VPC exists"
gcloud compute networks subnets create $SUBNET_NAME \
  --network=$VPC_NAME \
  --range=10.0.0.0/24 \
  --region=$REGION || echo "Subnet exists"

# === Step 2: Create Firewall Rules ===
echo ">>> Creating firewall rules..."
gcloud compute firewall-rules create $FIREWALL_NAME \
  --network=$VPC_NAME \
  --allow tcp:80 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=http-server \
  --quiet || echo "HTTP rule exists"

gcloud compute firewall-rules create $SSH_NAME \
  --network=$VPC_NAME \
  --allow tcp:22 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=ssh-server \
  --quiet || echo "SSH rule exists"

# === Step 3: Create Artifact Registry Docker repo ===
echo ">>> Creating Artifact Registry repository..."
gcloud artifacts repositories create $AR_REPO_NAME \
  --repository-format=docker \
  --location=$REGION \
  --description="Private Docker repo for Spring Petclinic" || echo "AR repository exists"

# Full AR image path
    AR_IMAGE="${REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_REPO_NAME}/${IMAGE_NAME}:latest"
    docker pull ${DOCKERHUB_IMAGE}
    # Configure Docker for Artifact Registry
    gcloud auth configure-docker ${REGION}-docker.pkg.dev -q
    # Tag and push to private Artifact Registry
    docker tag ${DOCKERHUB_IMAGE} ${AR_IMAGE}
    docker push ${AR_IMAGE}

# === Step 4: Create VM with startup script ===
echo ">>> Creating VM with startup script..."
gcloud compute instances create $VM_NAME \
  --zone=$ZONE \
  --machine-type=e2-medium \
  --subnet=$SUBNET_NAME \
  --tags=http-server,ssh-server \
  --image-family=debian-12 \
  --image-project=debian-cloud \
  --boot-disk-size=20GB \
  --metadata=startup-script="#!/bin/bash
    set -e
    apt-get update -y
    apt-get install -y docker.io
    systemctl enable docker
    systemctl start docker
    # Pull public Docker Hub image
    docker pull ${DOCKERHUB_IMAGE}
    # Run container
    sudo apt-get install -y qemu-user-static
    docker run --platform linux/arm64 -p 80:8080 ${DOCKERHUB_IMAGE}

  "

# === Step 5: Wait for startup script completion ===
echo ">>> Waiting 200 seconds for VM startup script to complete..."
sleep 200

# === Step 6: Get VM External IP ===
EXTERNAL_IP=$(gcloud compute instances describe $VM_NAME \
  --zone=$ZONE \
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

echo "🌐 Access your app at: http://$EXTERNAL_IP"
echo "🔑 SSH access via: gcloud compute ssh $VM_NAME --zone=$ZONE"



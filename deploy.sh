#!/bin/bash
BACKEND_GITHUB_REPO="git@github.com:bobyeoh/checkout-backend.git"
FRONTEND_GITHUB_REPO="git@github.com:bobyeoh/checkout-frontend.git"
CLONE_FRONTEND_DIR="cloned-frontend-repo"
CLONE_BACKEND_DIR="cloned-backend-repo"
AWS_REGION="ap-southeast-2"
IMAGE_TAG="latest"
APP_NAME="checkout"
ENVIRONMENT="production"
ECR_REPO_NAME="checkout-backend-$ENVIRONMENT"

git clone $BACKEND_GITHUB_REPO $CLONE_BACKEND_DIR
cd $CLONE_BACKEND_DIR

echo "login to AWS ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.$AWS_REGION.amazonaws.com
aws ecr describe-repositories --repository-names $ECR_REPO_NAME --region $AWS_REGION || aws ecr create-repository --repository-name $ECR_REPO_NAME --region $AWS_REGION

echo "Building docker image..."
docker build -t $ECR_REPO_NAME:$IMAGE_TAG .
ECR_REGISTRY=$(aws ecr describe-repositories --repository-names $ECR_REPO_NAME --query 'repositories[0].repositoryUri' --output text)
DOCKER_IMAGE_URI="$ECR_REGISTRY:$IMAGE_TAG"

echo "tagging Docker image..."
docker tag $ECR_REPO_NAME:$IMAGE_TAG $ECR_REGISTRY:$IMAGE_TAG

echo "push docker image to AWS ECR..."
docker push $ECR_REGISTRY:$IMAGE_TAG

cd ..
echo "init terraform..."
terraform init

echo "deploying infra..."
terraform apply -auto-approve \
  -var="app_name=$APP_NAME" \
  -var="environment=$ENVIRONMENT" \
  -var="region=$AWS_REGION" \
  -var="docker_image_uri=$DOCKER_IMAGE_URI" \
  -var='subnet_cidr_blocks=["10.0.1.0/24", "10.0.2.0/24"]' \
  -var="cidr_block=10.0.0.0/16"

echo "Waiting for Terraform outputs to become available..."
sleep 5

CLOUDFRONT_DOMAIN_NAME=$(terraform output -raw cloudfront_domain_name)
S3_BUCKET=$(terraform output -raw s3_bucket_name)


echo "cloning..."

git clone $FRONTEND_GITHUB_REPO $CLONE_FRONTEND_DIR

cd $CLONE_FRONTEND_DIR
echo "REACT_APP_API_GATEWAY=https://$CLOUDFRONT_DOMAIN_NAME/checkout/v1/" > .env
echo "building frontend..."
yarn
yarn build
echo "uploading..."
cd ..
aws s3 sync $CLONE_FRONTEND_DIR/build/ s3://$S3_BUCKET --acl public-read --delete
echo "cleaning..."
rm -rf $CLONE_FRONTEND_DIR
rm -rf $CLONE_BACKEND_DIR
echo "completed"

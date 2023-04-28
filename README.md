# Checkout infrastructure

This Terraform project sets up a complete AWS infrastructure for a web application called "checkout", which consists of a backend service and a frontend user interface. The backend service is developed using Golang and runs inside a Docker container, which is deployed on AWS Elastic Container Service (ECS). The frontend is built using React.js and is hosted on AWS S3, served through a CloudFront distribution. The infrastructure includes IAM roles, an ECR repository, a VPC with subnets, an RDS database, an ECS cluster, an S3 bucket, and a CloudFront distribution.

# Related resources

- [Frontend repository](https://github.com/bobyeoh/checkout-frontend)
- [Backend repository](https://github.com/bobyeoh/checkout-backend)
- [Terraform repository](https://github.com/bobyeoh/checkout-infra)
- [Deployed demo](https://d1orwtk97n23at.cloudfront.net/)

# Prerequisites

-   [Terraform](https://www.terraform.io/downloads.html) installed
-   AWS account with necessary permissions
-   [Docker](https://www.docker.com/get-started) installed
-   [AWS CLI](https://aws.amazon.com/cli/) installed and configured
-   [Node.js and Yarn](https://classic.yarnpkg.com/en/docs/install/) installed

## Project Structure

The project contains the following main files:

-   `main.tf`: The main Terraform configuration file, which defines the required providers, modules, and their respective configurations.
-   `deploy.sh`: A deployment script that takes care of building and deploying the frontend and backend components of the application, as well as initializing and applying the Terraform configuration.
  
The project is organized into separate Terraform modules, each responsible for a specific piece of the infrastructure:

-   `modules/iam`: IAM roles for the application
-   `modules/ecr`: ECR repository for the Docker images
-   `modules/vpc`: VPC and associated subnets and security groups
-   `modules/rds`: RDS database for the application
-   `modules/ecs`: ECS cluster, task definitions, and associated resources
-   `modules/s3`: S3 bucket for hosting the frontend assets
-   `modules/cloudfront`: CloudFront distribution for serving the frontend and API requests

## Deployment

To deploy the infrastructure, follow these steps:

1.  Clone the repository containing the Terraform configuration and deployment script:

>  git clone git@github.com:bobyeoh/checkout-infra.git
	cd checkout-infra
2. Make the deployment script executable:
> chmod +x deploy.sh
3. Run the deployment script:
> 
> ./deploy.sh

This script will perform the following actions:
    
    -   Clone the frontend and backend repositories
    -   Log in to the AWS ECR registry
    -   Build the backend Docker image and push it to ECR
    -   Initialize and apply the Terraform configuration
    -   Set up the frontend application with the appropriate API Gateway URL
    -   Build the frontend application and upload the assets to the S3 bucket
    -   Clean up the cloned repositories
    -   Finally, the entire system, including front-end, back-end, database, etc., will be automatically deployed to aws.
The script will output the CloudFront domain name for the application. Use this URL to access the deployed  application.

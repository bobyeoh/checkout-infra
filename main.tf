terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.64.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "iam" {
  source      = "./modules/iam"
  app_name    = var.app_name
  environment = var.environment
}

module "ecr" {
  source                 = "./modules/ecr"
  app_name               = var.app_name
  environment            = var.environment
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
}

module "vpc" {
  source             = "./modules/vpc"
  app_name           = var.app_name
  environment        = var.environment
  cidr_block         = var.cidr_block
  subnet_cidr_blocks = var.subnet_cidr_blocks
}

module "rds" {
  source                 = "./modules/rds"
  app_name               = var.app_name
  environment            = var.environment
  region                 = var.region
  db_name                = "${var.app_name}_${var.environment}"
  subnet_ids             = module.vpc.subnet_ids
  vpc_security_group_ids = [module.vpc.security_group_id]
}
module "ecs" {
  source                 = "./modules/ecs"
  app_name               = var.app_name
  environment            = var.environment
  region                 = var.region
  docker_image_uri       = var.docker_image_uri
  subnet_ids             = module.vpc.subnet_ids
  vpc_security_group_ids = [module.vpc.security_group_id]
  db_instance_endpoint   = module.rds.db_instance_endpoint
  db_instance_username   = module.rds.db_instance_username
  db_instance_password   = module.rds.db_instance_password
  db_name                = var.app_name
  vpc_id                 = module.vpc.vpc_id
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  ecs_task_role_arn      = module.iam.ecs_task_role_arn
}

module "s3" {
  source      = "./modules/s3"
  app_name    = var.app_name
  environment = var.environment
}

module "cloudfront" {
  source           = "./modules/cloudfront"
  app_name         = var.app_name
  environment      = var.environment
  s3_bucket_domain = module.s3.bucket_domain
  alb_dns_name     = module.ecs.alb_dns_name
}

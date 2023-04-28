locals {
  name_prefix = "${var.app_name}-${var.environment}"
  tags = {
    Name        = local.name_prefix
    Environment = var.environment
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags = merge(local.tags, { Name = "${local.name_prefix}-vpc" })
}

resource "aws_subnet" "subnets" {
  count = length(var.subnet_cidr_blocks)

  cidr_block = var.subnet_cidr_blocks[count.index]
  vpc_id     = aws_vpc.vpc.id

  tags = merge(local.tags, { Name = "${local.name_prefix}-subnet-${count.index}" })
}

resource "aws_security_group" "default" {
  name        = "${local.name_prefix}-default-sg"
  description = "Default security group for ${var.app_name} in ${var.environment} environment"
  vpc_id      = aws_vpc.vpc.id
  tags = local.tags
}
resource "aws_security_group_rule" "allow_rds_access" {
  security_group_id = aws_security_group.default.id

  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  self        = true
}
resource "aws_security_group_rule" "allow_port_8888" {
  security_group_id = aws_security_group.default.id

  type        = "ingress"
  from_port   = 8888
  to_port     = 8888
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "allow_outbound" {
  security_group_id = aws_security_group.default.id

  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(local.tags, { Name = "${local.name_prefix}-igw" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(local.tags, { Name = "${local.name_prefix}-public-rt" })
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count = length(var.subnet_cidr_blocks)

  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

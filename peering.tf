# Create VPC peering connection between our VPC and default VPC
resource "aws_vpc_peering_connection" "default" {
  count = var.is_peering_required ? 1 : 0
  
  vpc_id        = aws_vpc.main.id #requestor
  peer_vpc_id   = local.default_vpc_id #acceptor
  auto_accept   = true

  tags = merge(
    var.common_tags,
    var.vpc_peering_tags,
    {
        Name = "${local.resource_name}-default"
    }
  )
}

# Add the below for the resources in the our VPC Subnets to have access to other(default) VPC

# Create Routes for Public Route Table(Public Subnets) with default VPC CIDR
resource "aws_route" "public_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = local.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}

# Create Routes for Private Route Table(Private Subnets) with default VPC CIDR
resource "aws_route" "private_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = local.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}

# Create Routes for Public Route Table(Public Subnets) with default VPC CIDR
resource "aws_route" "database_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = local.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}


# Add the below for the resources in the default VPC to have access to OUR VPC

# Create Routes for default VPC Route Table with OUR VPC CIDR

resource "aws_route" "default_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = data.aws_route_table.main.route_table_id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}




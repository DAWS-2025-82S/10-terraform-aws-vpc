locals{
    resource_name = "${var.project_name}-${var.environment}"
    az_names = slice(data.aws_availability_zones.available.names, 0, 2) # get 2 zones from list
    default_vpc_id = data.aws_vpc.default.id
    default_vpc_cidr = data.aws_vpc.default.cidr_block
}
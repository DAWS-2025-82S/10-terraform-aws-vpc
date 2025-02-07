# get all availability zones and then use 2 zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Get default vpc
data "aws_vpc" "default" {
  default = true
}

# get default VPC route table
data "aws_route_table" "main" {
  vpc_id = local.default_vpc_id
  filter {
    name = "association.main"
    values = ["true"]
  }
}
resource "aws_db_subnet_group" "database_subnet_group" {
  name       = "${var.developer}-default_database_subnet_group"
  subnet_ids = aws_subnet.private_subnet.*.id
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}${var.availability_zones[count.index]}"

  tags = {
    Name = "Default public subnet. Developer - ${var.developer}."
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = "${var.aws_region}${var.availability_zones[count.index]}"

  tags = {
    Name = "Default private subnet. Developer - ${var.developer}."
  }
}

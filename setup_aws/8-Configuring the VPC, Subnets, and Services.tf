
/*8 - Configuring the VPC, Subnets, and Services */
/***Verified build in AWS ***/

# 8.1 Create the VPC
resource "aws_vpc" "outbound_security_vpc" {
  cidr_block = var.outbound_vpc.cidr
  enable_dns_hostnames = var.outbound_vpc.edit_dns_hostnames

  tags = {
    Name = var.outbound_vpc.vpc_name
  }
}
# 8.2 Create IP Subnets

resource "aws_subnet" "Outbound_Public_2a" {
  vpc_id            = aws_vpc.outbound_security_vpc.id
  cidr_block        = var.outbound_vpc.Outbound_Public_2a
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.outbound_vpc.Outbound_Public_2a_name
  }
}

resource "aws_subnet" "Outbound_Public_2b" {
  vpc_id            = aws_vpc.outbound_security_vpc.id
  cidr_block        = var.outbound_vpc.Outbound_Public_2b
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.outbound_vpc.Outbound_Public_2b_name
  }
}

resource "aws_subnet" "Outbound_TGW_2a" {
  vpc_id            = aws_vpc.outbound_security_vpc.id
  cidr_block        = var.outbound_vpc.Outbound_TGW_2a
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.outbound_vpc.Outbound_TGW_2a_name
  }
}

resource "aws_subnet" "Outbound_TGW_2b" {
  vpc_id            = aws_vpc.outbound_security_vpc.id
  cidr_block        = var.outbound_vpc.Outbound_TGW_2b
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.outbound_vpc.Outbound_TGW_2b_name
  }
}

resource "aws_subnet" "Outbound_Mgmt_2a" {
  vpc_id            = aws_vpc.outbound_security_vpc.id
  cidr_block        = var.outbound_vpc.Outbound_Mgmt_2a
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.outbound_vpc.Outbound_Mgmt_2a_name
  }
}

resource "aws_subnet" "Outbound_Mgmt_2b" {
  vpc_id            = aws_vpc.outbound_security_vpc.id
  cidr_block        = var.outbound_vpc.Outbound_Mgmt_2b
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.outbound_vpc.Outbound_Mgmt_2b_name
  }
}

# 8.3 Create a VPC Internet Gateway

resource "aws_internet_gateway" "vpc_outbound_security_igw" {
  vpc_id = "${aws_vpc.outbound_security_vpc.id}"

  tags = {
    Name = "TGW_Outbound Security IGW"
  }
}


# 8.4 Create the Transit Gateway Attachment

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_outbound_security" {
  vpc_id                                          = aws_vpc.outbound_security_vpc.id
  subnet_ids                                      = [aws_subnet.Outbound_TGW_2a.id, aws_subnet.Outbound_TGW_2b.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "TGW_tgw_attachment_Outbound_Security"
  }
}

# 8.5 Associate Attachments to the Route Tables
resource "aws_ec2_transit_gateway_route_table_association" "vpc_outbound2security_routetable" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_outbound_security.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw_security.id}"
}

resource "aws_ec2_transit_gateway_route_table_propagation" "outbound_security2security" {
 transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_outbound_security.id}"
 transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw_security.id}"
}


# 8.6 Create VPC Route Tables

resource "aws_route_table" "Public_Outbound_Security" {
  vpc_id = aws_vpc.outbound_security_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_outbound_security_igw.id
  }
  route {
     ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.vpc_outbound_security_igw.id
  }

  tags = {
    Name = "TGW_Public-Outbound-Security"
  }
}

resource "aws_route_table_association" "TGW_outboundsecuritysubnets2outboundsecurityroutetable2a" {
  subnet_id      = aws_subnet.Outbound_Public_2a.id
  route_table_id = aws_route_table.Public_Outbound_Security.id
}

resource "aws_route_table_association" "TGW_outboudsecuritysubnets2outboundsecurityroutetable2b" {
  subnet_id      = aws_subnet.Outbound_Public_2b.id
  route_table_id = aws_route_table.Public_Outbound_Security.id
}
//
resource "aws_route_table" "Mgmt_Outbound_Security" {
  vpc_id = aws_vpc.outbound_security_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_outbound_security_igw.id
  }
  route {
     ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.vpc_outbound_security_igw.id
  }
  route {
    cidr_block = "10.255.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name = "TGW_Mgmt-Outbound Security"
  }
}

resource "aws_route_table_association" "TGW_outboundmgmtsubnets2outboundsecurityroutetable2a" {
  subnet_id      = aws_subnet.Outbound_Mgmt_2a.id
  route_table_id = aws_route_table.Mgmt_Outbound_Security.id
}

resource "aws_route_table_association" "TGW_outboudmgmtsubnets2outboundsecurityroutetable2b" {
  subnet_id      = aws_subnet.Outbound_Mgmt_2b.id
  route_table_id = aws_route_table.Mgmt_Outbound_Security.id
}


# 8.7 Create Security Groups

resource "aws_security_group" "Outbound_Firewall_Public_sg" {
  name        = "TGW_Outbound-Firewall-Public"
  description = "Allow IPSec Traffic from the TGW"
  vpc_id      = aws_vpc.outbound_security_vpc.id

  tags = {
    Name = "TGW_Outbound-Firewall-Public"
  }

    //add default outbound rule
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    //add default for inbound
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" "Outbound_Firewall_Mgmt_sg" {
  name        = "TGW_Outbound-Firewall-Mgmt"
  description = "Allow inbound management to the firewall"
  vpc_id      = aws_vpc.outbound_security_vpc.id

  tags = {
    Name = "TGW_Outbound-Firewall-Mgmt"
  }

    //add default outbound rule
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = var.ssh_https_access_cidr_blocks
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
         cidr_blocks = var.ssh_https_access_cidr_blocks

    }

}
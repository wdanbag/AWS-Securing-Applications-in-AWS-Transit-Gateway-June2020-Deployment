/*  Deploying Inbound Security*/
/***Verified build in AWS ***/

//3.1 Create the VPC
resource "aws_vpc" "inbound_security_vpc" {
  cidr_block = var.inbound_vpc.cidr
  enable_dns_hostnames = var.inbound_vpc.edit_dns_hostnames

  tags = {
    Name = var.inbound_vpc.vpc_name
  }
}


//3.2 Create IP Subnets

resource "aws_subnet" "Inbound_Public_2a" {
  vpc_id            = aws_vpc.inbound_security_vpc.id
  cidr_block        = var.inbound_vpc.Inbound_Public_2a
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.inbound_vpc.Inbound_Public_2a_name
  }
}

resource "aws_subnet" "Inbound_FW_2a" {
  vpc_id            = aws_vpc.inbound_security_vpc.id
  cidr_block        = var.inbound_vpc.Inbound_FW_2a
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.inbound_vpc.Inbound_FW_2a_name
  }
}

resource "aws_subnet" "Inbound_TGW_2a" {
  vpc_id            = aws_vpc.inbound_security_vpc.id
  cidr_block        = var.inbound_vpc.Inbound_TGW_2a
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.inbound_vpc.Inbound_TGW_2a_name
  }
}

resource "aws_subnet" "Inbound_Mgmt_2a" {
  vpc_id            = aws_vpc.inbound_security_vpc.id
  cidr_block        = var.inbound_vpc.Inbound_Mgmt_2a
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.inbound_vpc.Inbound_Mgmt_2a_name
  }
}

resource "aws_subnet" "Inbound_Public_2b" {
  vpc_id            = aws_vpc.inbound_security_vpc.id
  cidr_block        = var.inbound_vpc.Inbound_Public_2b
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.inbound_vpc.Inbound_Public_2b_name
  }
}

resource "aws_subnet" "Inbound_FW_2b" {
  vpc_id            = aws_vpc.inbound_security_vpc.id
  cidr_block        = var.inbound_vpc.Inbound_FW_2b
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.inbound_vpc.Inbound_FW_2b_name
  }
}

resource "aws_subnet" "Inbound_TGW_2b" {
  vpc_id            = aws_vpc.inbound_security_vpc.id
  cidr_block        = var.inbound_vpc.Inbound_TGW_2b
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.inbound_vpc.Inbound_TGW_2b_name
  }
}

resource "aws_subnet" "Inbound_Mgmt_2b" {
  vpc_id            = aws_vpc.inbound_security_vpc.id
  cidr_block        = var.inbound_vpc.Inbound_Mgmt_2b
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.inbound_vpc.Inbound_Mgmt_2b_name
  }
}


//3.3 Create a VPC Internet Gateway

resource "aws_internet_gateway" "vpc_inbound_security_igw" {
  vpc_id = "${aws_vpc.inbound_security_vpc.id}"

  tags = {
    Name = "TGW_Inbound Security IGW"
  }
}
//3.4 Create Transit Gateway Attachments
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_inbound_security" {
  vpc_id                                          = aws_vpc.inbound_security_vpc.id
  subnet_ids                                      = [aws_subnet.Inbound_TGW_2a.id, aws_subnet.Inbound_TGW_2b.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "TGW_tgw_attachment_Inbound_Security"
  }
}

//3.5 Associate Attachments to the Route Tables
resource "aws_ec2_transit_gateway_route_table_association" "vpc_security2security_routetable" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_inbound_security.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw_security.id}"
}

resource "aws_ec2_transit_gateway_route_table_propagation" "inbound_security2security" {
 transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_inbound_security.id}"
 transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw_security.id}"
}

resource "aws_ec2_transit_gateway_route_table_propagation" "inbound_security2spokes" {
 transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_inbound_security.id}"
 transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw_spokes.id}"
}

//3.6 Create VPC Route Tables

resource "aws_route_table" "Public_Inbound_Security" {
  vpc_id = aws_vpc.inbound_security_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_inbound_security_igw.id
  }
  route {
     ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.vpc_inbound_security_igw.id
  }

  tags = {
    Name = "TGW_Public_Inbound Security"
  }
}

resource "aws_route_table_association" "TGW_inboundsecuritysubnets2inboundsecurityroutetable2a" {
  subnet_id      = aws_subnet.Inbound_Public_2a.id
  route_table_id = aws_route_table.Public_Inbound_Security.id
}

resource "aws_route_table_association" "TGW_inboudsecuritysubnets2inboundsecurityroutetable2b" {
  subnet_id      = aws_subnet.Inbound_Public_2b.id
  route_table_id = aws_route_table.Public_Inbound_Security.id
}

//
resource "aws_route_table" "Mgmt_Inbound_Security" {
  vpc_id = aws_vpc.inbound_security_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_inbound_security_igw.id
  }
  route {
     ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.vpc_inbound_security_igw.id
  }
  route {
    cidr_block = "10.255.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name = "TGW_Mgmt-Inbound Security"
  }
}

resource "aws_route_table_association" "TGW_inboundmgmtsubnets2inboundsecurityroutetable2a" {
  subnet_id      = aws_subnet.Inbound_Mgmt_2a.id
  route_table_id = aws_route_table.Mgmt_Inbound_Security.id
}

resource "aws_route_table_association" "TGW_inboudmgmtsubnets2inboundsecurityroutetable2b" {
  subnet_id      = aws_subnet.Inbound_Mgmt_2b.id
  route_table_id = aws_route_table.Mgmt_Inbound_Security.id
}

//
resource "aws_route_table" "Private_Inbound_Security" {
  vpc_id = aws_vpc.inbound_security_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
     ipv6_cidr_block        = "::/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name = "TGW_Private-Inbound Security"
  }
}

resource "aws_route_table_association" "TGW_fwsubnets2inboundsecurityroutetable2a" {
  subnet_id      = aws_subnet.Inbound_FW_2a.id
  route_table_id = aws_route_table.Private_Inbound_Security.id
}

resource "aws_route_table_association" "TGW_fwsubnets2inboundsecurityroutetable2b" {
  subnet_id      = aws_subnet.Inbound_FW_2b.id
  route_table_id = aws_route_table.Private_Inbound_Security.id
}




//3.7 Create Security Groups

resource "aws_security_group" "Inbound_Firewall_Public" {
  name        = var.inboud_fw_public_sg.sg_name
  description = var.inboud_fw_public_sg.sg_description
  vpc_id      = aws_vpc.inbound_security_vpc.id

  tags = {
    Name = var.inboud_fw_public_sg.sg_name
  }

    //add default outbound rule
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "inbound_FW_Public_allow_all_ingress" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.Inbound_Firewall_Public.id
}

//

resource "aws_security_group" "inboud_fw_mgmt_sg" {
  name        = var.inboud_fw_mgmt_sg.sg_name
  description = var.inboud_fw_mgmt_sg.sg_description
  vpc_id      = aws_vpc.inbound_security_vpc.id

  tags = {
    Name = var.inboud_fw_mgmt_sg.sg_name
  }

    //add default outbound rule
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "inbound_inboud_fw_mgmt_allow_ssh_ingress" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = var.ssh_https_access_cidr_blocks

  security_group_id = aws_security_group.inboud_fw_mgmt_sg.id
}

resource "aws_security_group_rule" "inbound_inboud_fw_mgmt_allow_https_ingress" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = var.ssh_https_access_cidr_blocks

  security_group_id = aws_security_group.inboud_fw_mgmt_sg.id
}

//

resource "aws_security_group" "inboud_fw_private_sg" {
  name        = var.inboud_fw_private_sg.sg_name
  description = var.inboud_fw_private_sg.sg_description
  vpc_id      = aws_vpc.inbound_security_vpc.id

   tags = {
      Name = var.inboud_fw_private_sg.sg_name
  }

    //add default outbound rule
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "inboud_fw_private_sg_allow_all_ingress" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["10.0.0.0/8"]


  security_group_id = aws_security_group.inboud_fw_private_sg.id
}


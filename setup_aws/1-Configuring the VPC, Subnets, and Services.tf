/*  Deploying AWS VPC Infrastructure */
/***Verified build in AWS ***/

// 1.1 Create the Spoke VPCs
resource "aws_vpc" "web_spoke_vpc" {
  cidr_block = var.web_vpc.cidr
  enable_dns_hostnames = var.web_vpc.edit_dns_hostnames

  tags = {
    Name = var.web_vpc.vpc_name
  }
}

resource "aws_vpc" "db_spoke_vpc" {
  cidr_block = var.db_vpc.cidr
  enable_dns_hostnames = var.db_vpc.edit_dns_hostnames

  tags = {
    Name = var.db_vpc.vpc_name
  }
}


// 1.2 Create IP Subnets for the Spoke VPCs

resource "aws_subnet" "Web_server_2a_subnet" {
  vpc_id            = aws_vpc.web_spoke_vpc.id
  cidr_block        = var.Web_server_2a_subnet.cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.Web_server_2a_subnet.subnet_name
  }
}

resource "aws_subnet" "Web_server_2b_subnet" {
  vpc_id            = aws_vpc.web_spoke_vpc.id
  cidr_block        = var.Web_server_2b_subnet.cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.Web_server_2b_subnet.subnet_name
  }
}

resource "aws_subnet" "DB_2a_subnet" {
  vpc_id            = aws_vpc.db_spoke_vpc.id
  cidr_block        = var.DB_2a_subnet.cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.DB_2a_subnet.subnet_name
  }
}

resource "aws_subnet" "DB_2b_subnet" {
  vpc_id            = aws_vpc.db_spoke_vpc.id
  cidr_block        = var.DB_2b_subnet.cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.DB_2b_subnet.subnet_name
  }
}



// 1.3 Create Security Groups for the Spoke VPCs
resource "aws_security_group" "Web_Private" {
  name        = var.web_private_sg.sg_name
  description = var.web_private_sg.sg_description
  vpc_id      = aws_vpc.web_spoke_vpc.id

    //add default outbound rule
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_security_group_rule" "allow_all_ingress_web" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["10.0.0.0/8"]

  security_group_id = aws_security_group.Web_Private.id
}

resource "aws_security_group" "DB_Private" {
  name        = var.db_private_sg.sg_name
  description = var.db_private_sg.sg_description
  vpc_id      = aws_vpc.db_spoke_vpc.id

    //add default outbound rule
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group_rule" "allow_all_ingress_db" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["10.0.0.0/8"]

  security_group_id = aws_security_group.DB_Private.id
}

// 1.4 Create a Transit Gateway
resource "aws_ec2_transit_gateway" "tgw" {
  description                     = var.TGW.description
  vpn_ecmp_support                = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  auto_accept_shared_attachments  = "disable"
  tags = {
    Name = var.TGW.name
  }
}


// 1.5 Create Transit Gateway Route Tables
resource "aws_ec2_transit_gateway_route_table" "tgw_security" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  tags = {
    Name = "TGW_Security"
  }
}

resource "aws_ec2_transit_gateway_route_table" "tgw_spokes" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  tags = {
    Name = "TGW_Spokes"
  }
}


resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_db" {
  vpc_id                                          = aws_vpc.db_spoke_vpc.id
  subnet_ids                                      = [aws_subnet.DB_2a_subnet.id, aws_subnet.DB_2b_subnet.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "TGW_tgw_attachment_db"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_web" {
  vpc_id                                          = aws_vpc.web_spoke_vpc.id
  subnet_ids                                      = [aws_subnet.Web_server_2a_subnet.id, aws_subnet.Web_server_2b_subnet.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "TGW_tgw_attachment_web"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_management" {
  vpc_id                                          = var.vpc_panorama_managment.vpc_id
  subnet_ids                                      = [var.vpc_panorama_managment.subnet_management_id_2a, var.vpc_panorama_managment.subnet_management_id_2b]
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "TGW_tgw_attachment_management"
  }
}

// 1.7 Associate Attachments to the Route Tables
resource "aws_ec2_transit_gateway_route_table_association" "vpc_web2spokes_routetable" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_web.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw_spokes.id}"
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc_db2spokes_routetable" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_db.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw_spokes.id}"
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc_management2security_routetable" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_management.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw_security.id}"
}

resource "aws_ec2_transit_gateway_route_table_propagation" "web" {
 transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_web.id}"
 transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw_security.id}"
}
resource "aws_ec2_transit_gateway_route_table_propagation" "db" {
 transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_db.id}"
 transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw_security.id}"
}

resource "aws_ec2_transit_gateway_route_table_propagation" "management" {
 transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_management.id}"
 transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw_security.id}"
}

# //**************WMB - Added for troubleshooting - may need to remove 
# resource "aws_ec2_transit_gateway_route_table_propagation" "management2spokes" {
#  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw_management.id}"
#  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw_spokes.id}"
# }

// 1.8 Create Spoke VPC Route Tables
resource "aws_route_table" "TGW_Web" {
  vpc_id = aws_vpc.web_spoke_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
     ipv6_cidr_block        = "::/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name = "TGW_Web"
  }
}

resource "aws_route_table_association" "TGW_websubnets2webroutetable2a" {
  subnet_id      = aws_subnet.Web_server_2a_subnet.id
  route_table_id = aws_route_table.TGW_Web.id
}

resource "aws_route_table_association" "TGW_websubnets2webroutetable2b" {
  subnet_id      = aws_subnet.Web_server_2b_subnet.id
  route_table_id = aws_route_table.TGW_Web.id
}

resource "aws_route_table" "TGW_DB" {
  vpc_id = aws_vpc.db_spoke_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
     ipv6_cidr_block        = "::/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name = "TGW_DB"
  }
}

resource "aws_route_table_association" "TGW_dbsubnets2dbroutetable2a" {
  subnet_id      = aws_subnet.DB_2a_subnet.id
  route_table_id = aws_route_table.TGW_DB.id
}

resource "aws_route_table_association" "TGW_dbsubnets2dbroutetable2b" {
  subnet_id      = aws_subnet.DB_2b_subnet.id
  route_table_id = aws_route_table.TGW_DB.id
}

// 1.9 Modify Management VPC Routes and Security Group
/*  Deviating from the TGW guide here and putting explicitly the Inbound/OUtbound/EW cidr blocks instead of 10.0.0.8 due 
    to collision with implementing the the single vpc model which uses 10.100.0.0.  Note that the Inbound cidr has been changed
    to use 10.103.0.0/16 due to the collision of the Single VPC model which uses the same cidr block for the single vpc
*/
resource "aws_route" "management2tgw_outbound" {
  route_table_id            = var.vpc_panorama_managment.panorama_management_route_table
  destination_cidr_block    = var.outbound_vpc.cidr
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "management2tgw_ew" {
  route_table_id            = var.vpc_panorama_managment.panorama_management_route_table
  destination_cidr_block    = var.ew_vpc.cidr
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "management2tgw_inbound" {
  route_table_id            = var.vpc_panorama_managment.panorama_management_route_table
  destination_cidr_block    = var.inbound_vpc.cidr
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

resource "aws_security_group_rule" "outbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = [var.outbound_vpc.cidr]
  security_group_id = var.vpc_panorama_managment.panorama_sg
}

resource "aws_security_group_rule" "inbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = [var.inbound_vpc.cidr]
  security_group_id = var.vpc_panorama_managment.panorama_sg
}

resource "aws_security_group_rule" "ew" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = [var.ew_vpc.cidr]
  security_group_id = var.vpc_panorama_managment.panorama_sg
}

/*  The following sections of the guide need to be done in Panorama - Am not using Terraform Pan provider for this currently
    2.1 Configure Device Groups
    2.2 Configure Log Forwarding Objects
    2.3 Create a Baseline Template
    2.4 Configure the Firewall Baseline Settings Template
*/
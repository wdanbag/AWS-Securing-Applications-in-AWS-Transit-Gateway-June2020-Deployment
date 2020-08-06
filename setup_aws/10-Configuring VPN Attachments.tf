/*  Configuring VPN Attachments */


# 10.1 Create Customer Gateways
resource "aws_customer_gateway" "outbound_vmseries_a" {
  bgp_asn    = var.outbound_customer_gateway_vpn_attachements.bgp
  ip_address = module.ngfw_outbound_a.eip_untrust
  type       = "ipsec.1"

  tags = {
    Name = var.outbound_customer_gateway_vpn_attachements.name_a
  }
}


resource "aws_customer_gateway" "outbound_vmseries_b" {
  bgp_asn    = var.outbound_customer_gateway_vpn_attachements.bgp
  ip_address = module.ngfw_outbound_b.eip_untrust
  type       = "ipsec.1"

  tags = {
    Name = var.outbound_customer_gateway_vpn_attachements.name_b
  }
}


# 10.2 Create Transit Gateway VPN Attachments

resource "aws_vpn_connection" "outbound_vmseries_a" {
  customer_gateway_id = aws_customer_gateway.outbound_vmseries_a.id
  transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  type                = "ipsec.1"
  tunnel1_inside_cidr = var.outbound_customer_gateway_vpn_attachements.tunnel_cidr_a1
  tunnel2_inside_cidr = var.outbound_customer_gateway_vpn_attachements.tunnel_cidr_a2
  tunnel1_preshared_key = var.pre_sharedkey
  tunnel2_preshared_key = var.pre_sharedkey

  tags = {
      Name = "TGW_vpn_attachment_outbound_vmseries_a"
  }

}



resource "aws_vpn_connection" "outbound_vmseries_b" {
  customer_gateway_id = aws_customer_gateway.outbound_vmseries_b.id
  transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  type                = "ipsec.1"
  tunnel1_inside_cidr = var.outbound_customer_gateway_vpn_attachements.tunnel_cidr_b1
  tunnel2_inside_cidr = var.outbound_customer_gateway_vpn_attachements.tunnel_cidr_b2
  tunnel1_preshared_key = var.pre_sharedkey
  tunnel2_preshared_key = var.pre_sharedkey

  tags = {
      Name = "TGW_vpn_attachment_outbound_vmseries_b"
  }

}

# 10.3 Associate Attachments to the Route Tables

resource "aws_ec2_transit_gateway_route_table_association" "cgw_transit_gateway_route_table_association_a" {
  transit_gateway_attachment_id 	= aws_vpn_connection.outbound_vmseries_a.transit_gateway_attachment_id
  transit_gateway_route_table_id 	= aws_ec2_transit_gateway_route_table.tgw_security.id
}

# //***WMB - Appears to be incorrect.  It should be spoke here so commenting out and adding spokes
# resource "aws_ec2_transit_gateway_route_table_propagation" "cgw_transit_gateway_route_table_propagation_a" {
#     transit_gateway_attachment_id 	= aws_vpn_connection.outbound_vmseries_a.transit_gateway_attachment_id
#   transit_gateway_route_table_id 	= aws_ec2_transit_gateway_route_table.tgw_security.id
# }

//***WMB - added this since spokes need outbound VPN to work
resource "aws_ec2_transit_gateway_route_table_propagation" "cgw_transit_gateway_route_table_propagation_a_spoke" {
    transit_gateway_attachment_id 	= aws_vpn_connection.outbound_vmseries_a.transit_gateway_attachment_id
  transit_gateway_route_table_id 	= aws_ec2_transit_gateway_route_table.tgw_spokes.id
}



//
resource "aws_ec2_transit_gateway_route_table_association" "cgw_transit_gateway_route_table_association_b" {
  transit_gateway_attachment_id 	= aws_vpn_connection.outbound_vmseries_b.transit_gateway_attachment_id
  transit_gateway_route_table_id 	= aws_ec2_transit_gateway_route_table.tgw_security.id
}

# //***WMB - Appears to be incorrect.  It should be spoke here so commenting out and adding spokes
# resource "aws_ec2_transit_gateway_route_table_propagation" "cgw_transit_gateway_route_table_propagation_b" {
#   transit_gateway_attachment_id 	= aws_vpn_connection.outbound_vmseries_b.transit_gateway_attachment_id
#   transit_gateway_route_table_id 	= aws_ec2_transit_gateway_route_table.tgw_security.id
# }

//***WMB - added this since spokes need outbound VPN to work
resource "aws_ec2_transit_gateway_route_table_propagation" "cgw_transit_gateway_route_table_propagation_b_spoke" {
  
  transit_gateway_attachment_id 	= aws_vpn_connection.outbound_vmseries_b.transit_gateway_attachment_id
  transit_gateway_route_table_id 	= aws_ec2_transit_gateway_route_table.tgw_spokes.id
  
}


# 10.4 Record the Outside IP Address of the VPN Tunnels 


output "Outbound-FW-1_outbound-vmseries-a" {
    value = "${var.outbound_vmseries_a.public_ip_address} VPN Tunnel Variables for step 13.10"
}

output "Outbound-FW-1__Tunnel-Interface-IP-1" {
  value = "${aws_vpn_connection.outbound_vmseries_a.tunnel1_cgw_inside_address}/30"
}

output "Outbound-FW-1__BGP-Router-ID" {
  value = "${module.ngfw_outbound_a.eip_untrust}"
}

output "Outbound-FW-1__BGP-AS" {
  value = "${var.outbound_customer_gateway_vpn_attachements.bgp}"
}

output "Outbound-FW-1__Route" {
  value = "${var.outbound_customer_gateway_vpn_attachements.route}"
}

output "Outbound-FW-1__Tunnel-Interface-Peer-1" {
  value = "${aws_vpn_connection.outbound_vmseries_a.tunnel1_vgw_inside_address}"
}

output "Outbound-FW-1__IKE-Gateway-Peer-1" {
  value = "${aws_vpn_connection.outbound_vmseries_a.tunnel1_address}"
}

output "Outbound-FW-1__Tunnel-Interface-IP-2" {
  value = "${aws_vpn_connection.outbound_vmseries_a.tunnel2_cgw_inside_address}/30"
}

output "Outbound-FW-1__Tunnel-Interface-Peer-2" {
  value = "${aws_vpn_connection.outbound_vmseries_a.tunnel2_vgw_inside_address}"
}

output "Outbound-FW-1__IKE-Gateway-Peer-2" {
  value = "${aws_vpn_connection.outbound_vmseries_a.tunnel2_address}"
}









///////


output "Outbound-FW-2__outbound-vmseries-b"{
    value = "${var.outbound_vmseries_b.public_ip_address} VPN Tunnel Variables for step 13.10"
}

output "Outbound-FW-2__Tunnel-Interface-IP-1" {
  value = "${aws_vpn_connection.outbound_vmseries_b.tunnel1_cgw_inside_address}/30"
}

output "Outbound-FW-2__BGP-Router-ID" {
  value = "${module.ngfw_outbound_b.eip_untrust}"
}

output "Outbound-FW-2__BGP-AS" {
  value = "${var.outbound_customer_gateway_vpn_attachements.bgp}"
}

output "Outbound-FW-2__Route" {
  value = "${var.outbound_customer_gateway_vpn_attachements.route}"
}

output "Outbound-FW-2__Tunnel-Interface-Peer-1" {
  value = "${aws_vpn_connection.outbound_vmseries_b.tunnel1_vgw_inside_address}"
}

output "Outbound-FW-2__IKE-Gateway-Peer-1" {
  value = "${aws_vpn_connection.outbound_vmseries_b.tunnel1_address}"
}

output "Outbound-FW-2__Tunnel-Interface-IP-2" {
  value = "${aws_vpn_connection.outbound_vmseries_b.tunnel2_cgw_inside_address}/30"
}

output "Outbound-FW-2__Tunnel-Interface-Peer-2" {
  value = "${aws_vpn_connection.outbound_vmseries_b.tunnel2_vgw_inside_address}"
}

output "Outbound-FW-2__IKE-Gateway-Peer-2" {
  value = "${aws_vpn_connection.outbound_vmseries_b.tunnel2_address}"
}



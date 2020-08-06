# /* 13 - Configuring VM-Series Firewalls for VPN to the Transit Gateway */



# #13.10 Configure Variable Values
# resource "panos_panorama_template_variable" "BGP-Router-ID_a" {
#     template = "${var.outbound_template_stacks.stack_outbound_a}"
#     name = "$BGP-Router-ID"
#     value = module.ngfw_outbound_a.eip_untrust
# }

# resource "panos_panorama_template_variable" "BGP-AS_a" {
#     template = "${var.outbound_template_stacks.stack_outbound_a}"
#     name = "$BGP-AS"
#     value = var.outbound_customer_gateway_vpn_attachements.bgp
# }

# resource "panos_panorama_template_variable" "Route_a" {
#     template = "${var.outbound_template_stacks.stack_outbound_a}"
#     name = "$Route"
#     value = var.outbound_customer_gateway_vpn_attachements.route
# }

# resource "panos_panorama_template_variable" "Tunnel-Interface-IP-1_a" {
#     template = "${var.outbound_template_stacks.stack_outbound_a}"
#     name = "$Tunnel-Interface-IP-1"
#     value = "${aws_vpn_connection.outbound_vmseries_a.tunnel1_cgw_inside_address}/30"
# }

# resource "panos_panorama_template_variable" "Tunnel-Interface-Peer-1_a" {
#     template = "${var.outbound_template_stacks.stack_outbound_a}"
#     name = "$Tunnel-Interface-Peer-1"
#     value = aws_vpn_connection.outbound_vmseries_a.tunnel1_vgw_inside_address
# }
# resource "panos_panorama_template_variable" "Tunnel-Interface-Peer-2_a" {
#     template = "${var.outbound_template_stacks.stack_outbound_a}"
#     name = "$Tunnel-Interface-Peer-2"
#     value = aws_vpn_connection.outbound_vmseries_a.tunnel2_vgw_inside_address
# }

# resource "panos_panorama_template_variable" "IKE-Gateway-Peer-1_a" {
#     template = "${var.outbound_template_stacks.stack_outbound_a}"
#     name = "$IKE-Gateway-Peer-1"
#     value = aws_vpn_connection.outbound_vmseries_a.tunnel1_address
# }


# resource "panos_panorama_template_variable" "Tunnel-Interface-IP-2_a" {
#     template = "${var.outbound_template_stacks.stack_outbound_a}"
#     name = "$Tunnel-Interface-IP-2"
#     value = "${aws_vpn_connection.outbound_vmseries_a.tunnel2_cgw_inside_address}/30"  
# }

# resource "panos_panorama_template_variable" "IKE-Gateway-Peer-2_a" {
#     template = "${var.outbound_template_stacks.stack_outbound_a}"
#     name = "$IKE-Gateway-Peer-2"
#     value = aws_vpn_connection.outbound_vmseries_a.tunnel2_address
# }

# //

# resource "panos_panorama_template_variable" "BGP-Router-ID_b" {
#     template = "${var.outbound_template_stacks.stack_outbound_b}"
#     name = "$BGP-Router-ID"
#     value = module.ngfw_outbound_b.eip_untrust
# }

# resource "panos_panorama_template_variable" "BGP-AS_b" {
#     template = "${var.outbound_template_stacks.stack_outbound_b}"
#     name = "$BGP-AS"
#     value = var.outbound_customer_gateway_vpn_attachements.bgp
# }

# resource "panos_panorama_template_variable" "Route_b" {
#     template = "${var.outbound_template_stacks.stack_outbound_b}"
#     name = "$Route"
#     value = var.outbound_customer_gateway_vpn_attachements.route
# }

# resource "panos_panorama_template_variable" "Tunnel-Interface-IP-1_b" {
#     template = "${var.outbound_template_stacks.stack_outbound_b}"
#     name = "$Tunnel-Interface-IP-1"
#     value = "${aws_vpn_connection.outbound_vmseries_b.tunnel1_cgw_inside_address}/30"
# }

# resource "panos_panorama_template_variable" "Tunnel-Interface-Peer-1_b" {
#     template = "${var.outbound_template_stacks.stack_outbound_b}"
#     name = "$Tunnel-Interface-Peer-1"
#     value = aws_vpn_connection.outbound_vmseries_b.tunnel1_vgw_inside_address
# }

# resource "panos_panorama_template_variable" "IKE-Gateway-Peer-1_b" {
#     template = "${var.outbound_template_stacks.stack_outbound_b}"
#     name = "$IKE-Gateway-Peer-1"
#     value = aws_vpn_connection.outbound_vmseries_b.tunnel1_address
# }

# resource "panos_panorama_template_variable" "Tunnel-Interface-Peer-2_b" {
#     template = "${var.outbound_template_stacks.stack_outbound_b}"
#     name = "$Tunnel-Interface-Peer-2"
#     value = aws_vpn_connection.outbound_vmseries_b.tunnel2_vgw_inside_address
# }

# resource "panos_panorama_template_variable" "Tunnel-Interface-IP-2_b" {
#     template = "${var.outbound_template_stacks.stack_outbound_b}"
#     name = "$Tunnel-Interface-IP-2"
#     value = "${aws_vpn_connection.outbound_vmseries_b.tunnel2_cgw_inside_address}/30"  
# }

# resource "panos_panorama_template_variable" "IKE-Gateway-Peer-2_b" {
#     template = "${var.outbound_template_stacks.stack_outbound_b}"
#     name = "$IKE-Gateway-Peer-2"
#     value = aws_vpn_connection.outbound_vmseries_b.tunnel2_address
# }


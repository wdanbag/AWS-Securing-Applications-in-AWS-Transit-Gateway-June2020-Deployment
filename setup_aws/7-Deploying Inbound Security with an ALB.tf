/*  7 - Deploying Inbound Security with an Application Load Balancer */
/***Verified build in AWS ***/

//  7.1 Configure the Public Application Load Balancer


resource "aws_lb_target_group" "inbound_fw_target_group" {
  name          = "TGW-inbound-vmseries"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      =  aws_vpc.inbound_security_vpc.id

    health_check {
        path = "/"
        protocol = "HTTP"
        interval    = 5
        timeout     = 3
  }

}

resource "aws_alb" "inbound_http_alb"{
  name               = var.inbound_http_alb.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.Inbound_Firewall_Public.id}"]
  ip_address_type    = "ipv4"
  subnets            = ["${aws_subnet.Inbound_Public_2a.id}", "${aws_subnet.Inbound_Public_2b.id}"]

  enable_deletion_protection = false
  
  tags = {
    Name = var.inbound_http_alb.name
  }

}

resource "aws_lb_listener" "inbound_fw_target_group" {
  load_balancer_arn = aws_alb.inbound_http_alb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.inbound_fw_target_group.arn}"
  }
}

resource "aws_lb_target_group_attachment" "inbound_targtgroup_attachmement_a" {
  target_group_arn = "${aws_lb_target_group.inbound_fw_target_group.arn}"
  target_id        = "10.103.0.10"
  port             = 80
}

resource "aws_lb_target_group_attachment" "inbound_targtgroup_attachmement_b" {
  target_group_arn = "${aws_lb_target_group.inbound_fw_target_group.arn}"
  target_id        = "10.103.128.10"
  port             = 80
}

output "Inbound_Public_ALB" {
  value = "The Inbound Pubic Application Load Balancer FQDN is:  ${aws_alb.inbound_http_alb.dns_name}"
}


//7.2 Configure the NAT Policy - This makes the internal load balancer for use to manually configure the Nat rule in 7.2 of the guide
//While not explicitly created, an internal ALB is created here to be used in a manual guide step 7.2 and in a later run of the script 
//to create the web servers and the web servers are added as targets to the load balancer

resource "aws_lb_target_group" "internal_webservers" {
  name          = "TGW-internal-webservers"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      =  aws_vpc.web_spoke_vpc.id

    health_check {
        path = "/"
        protocol = "HTTP"
        interval    = 5
        timeout     = 3
  }

}

resource "aws_alb" "internal_http_alb"{
  name               = "TGW-Internal-ALB"
  internal           = true
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.Web_Private.id}"]
  ip_address_type    = "ipv4"
  subnets            = ["${aws_subnet.Web_server_2a_subnet.id}", "${aws_subnet.Web_server_2b_subnet.id}"]

  enable_deletion_protection = false
  
  tags = {
    Name = "TGW_Internal_ALB"
  }

}

resource "aws_lb_listener" "internal_webservers" {
  load_balancer_arn = aws_alb.internal_http_alb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.internal_webservers.arn}"
  }
}

output "Internal_Webserver_ALB" {
  value = "Internal Webserver Application Load Balancer FQDN is:  ${aws_alb.internal_http_alb.dns_name}"
}

variable create_webservers{
    default = 0
}



resource "aws_instance" "webserver_1" {
  count = var.create_webservers
  
  user_data                            = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo “Palo Alto Networks VM-Series Firewall test from $(hostname -f)” > /var/www/html/index.html
EOF

  ami           = var.amazon_linux_2_ami_id
  instance_type = "t2.micro"
  key_name      = "${var.aws_key}"
  security_groups = [aws_security_group.Web_Private.id]
  subnet_id = aws_subnet.Web_server_2a_subnet.id
  monitoring = false
  tags = {
    Name = "TGW_Web-Server-2a"
  }
}

resource "aws_lb_target_group_attachment" "internal_web_a" {
  count = var.create_webservers
  target_group_arn = "${aws_lb_target_group.internal_webservers.arn}"
  target_id        = aws_instance.webserver_1[count.index].id
  port             = 80
}



resource "aws_instance" "webserver_2" {
  count = var.create_webservers
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "stop"
   user_data                            = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo “Palo Alto Networks VM-Series Firewall test from $(hostname -f)” > /var/www/html/index.html
EOF

  ami           = var.amazon_linux_2_ami_id
  instance_type = "t2.micro"
  key_name      = "${var.aws_key}"
  security_groups = [aws_security_group.Web_Private.id]
  subnet_id = aws_subnet.Web_server_2b_subnet.id
  tags = {
    Name = "TGW_Web-Server-2b"
  }
}

resource "aws_lb_target_group_attachment" "internal_web_b" {
  count = var.create_webservers
  target_group_arn = "${aws_lb_target_group.internal_webservers.arn}"
  target_id        = aws_instance.webserver_2[count.index].id
  port             = 80
}

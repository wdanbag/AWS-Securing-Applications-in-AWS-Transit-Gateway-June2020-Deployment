/* 9 - Deploying a VM-Series Instance on AWS */

# 9.1 Create the VM-Series Firewalls
# 9.2 Create Elastic Network Interfaces for the VM-Series Firewalls
# 9.3 Attach the Interfaces to the Firewalls
# 9.4 Label the Primary Interfaces for the VM-Series Instance
# 9.5 Create Elastic IP Addresses for the VM-Series Firewall
# 9.6 Log in to the VM-Series Firewall
# 9.7 License the VM-Series Firewalls

////////////////////////////////////////////////////////////////////////////////
// Create a BootStrap S3 Bucket, IAM access role and firewall for ngfw_outbound_a
////////////////////////////////////////////////////////////////////////////////
module "s3bucket_outbound_a" {
  source = "./create_bootstrap_bucket/"
  bucket = var.s3bootstrapbuckets.outbound_s3bucket_a
  init_cfg_source = "bootstrap_files/init-cfg._outbound_a.txt"
  license_content = var.vm_series_authcodes.outbound_s3bucket_a
}

//Create the NGFW
module "ngfw_outbound_a" {
  source = "./vm-series-outbound-e-w/"

  name = var.outbound_vmseries_a.namee
  aws_key = var.aws_key

  instance_type           = var.fw_instance_type
  ngfw_versionn            = var.ngfw_version
  ngfw_license_typee       = var.ngfw_license_type
  
  untrust_subnet_id         = aws_subnet.Outbound_Public_2a.id
  untrust_security_group_id = aws_security_group.Outbound_Firewall_Public_sg.id
  untrustfwip               = var.outbound_vmseries_a.public_ip_address

  management_subnet_id         = aws_subnet.Outbound_Mgmt_2a.id
  management_security_group_id = aws_security_group.Outbound_Firewall_Mgmt_sg.id
  management_ip                 = var.outbound_vmseries_a.managment_ip_address

  bootstrap_profile = "${module.s3bucket_outbound_a.iam_profile}"
  bootstrap_s3bucket = var.s3bootstrapbuckets.outbound_s3bucket_a

  tgw_id = aws_ec2_transit_gateway.tgw.id

  aws_region = var.aws_region
}

output "Outbound-FW-1-MGMT" {
  value = "Access the firewall MGMT via:  https://${module.ngfw_outbound_a.eip_mgmt}"
}



////////////////////////////////////////////////////////////////////////////////
// Create a BootStrap S3 Bucket, IAM access role and firewall for ngfw_outbound_b
////////////////////////////////////////////////////////////////////////////////
module "s3bucket_outbound_b" {
  source = "./create_bootstrap_bucket/"
  bucket = var.s3bootstrapbuckets.outbound_s3bucket_b
  init_cfg_source = "bootstrap_files/init-cfg._outbound_b.txt"
  license_content = var.vm_series_authcodes.outbound_s3bucket_b
}


//Create the NGFW
module "ngfw_outbound_b" {
  source = "./vm-series-outbound-e-w/"

  name = var.outbound_vmseries_b.namee
  aws_key = var.aws_key

  instance_type           = var.fw_instance_type
  ngfw_versionn            = var.ngfw_version
  ngfw_license_typee       = var.ngfw_license_type
  
  untrust_subnet_id         = aws_subnet.Outbound_Public_2b.id
  untrust_security_group_id = aws_security_group.Outbound_Firewall_Public_sg.id
  untrustfwip               = var.outbound_vmseries_b.public_ip_address

  management_subnet_id         = aws_subnet.Outbound_Mgmt_2b.id
  management_security_group_id = aws_security_group.Outbound_Firewall_Mgmt_sg.id
  management_ip                 = var.outbound_vmseries_b.managment_ip_address

  bootstrap_profile = "${module.s3bucket_outbound_b.iam_profile}"
  bootstrap_s3bucket = var.s3bootstrapbuckets.outbound_s3bucket_b

  tgw_id = aws_ec2_transit_gateway.tgw.id

  aws_region = var.aws_region
}

output "Outbound-FW-2-MGMT" {
  value = "Access the firewall MGMT via:  https://${module.ngfw_outbound_b.eip_mgmt}"
}



//4.2 Create Elastic Network Interfaces for the VM-Series Firewalls
//4.3 Attach the Interfaces to the Firewalls
//4.4 Label the Primary Interfaces for the VM-Series Instance
//4.5 Create Elastic IP Addresses for the VM-Series Firewall
//4.6 Log in to the VM-Series Firewall
//4.7 License the VM-Series Firewalls









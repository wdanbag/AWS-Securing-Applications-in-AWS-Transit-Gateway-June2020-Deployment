////////////////////////////////////////////////////////////
//This section should be verified and modified accordingly.
////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////
//The following items are not in this file but must or should as noted be changed in other files
//In files:
//  bootstrap_files/init-cfg._inbound_a.txt
//  bootstrap_files/init-cfg._inbound_b.txt
//  bootstrap_files/init-cfg._outbound_a.txt
//  bootstrap_files/init-cfg._outbound_b.txt
//must change the following items:
//  panorama-server  (Primary Panorama Server)
//  panorama-server-2 (Secondary Panorama Server)
//  vm-auth-key (Change to your generated vm-auth-key - see https://docs.paloaltonetworks.com/vm-series/9-1/vm-series-deployment/bootstrap-the-vm-series-firewall/generate-the-vm-auth-key-on-panorama.html)
//
//Might change the following if you have altered your Panorama device group and templates outside of the guide
//  tplname 
//  dgname
//
//////////////////////////////////////////////////////////////////////////////////////////////////////


//**Must Change**
//These S3 buckets need to be uniquie so please change
variable s3bootstrapbuckets {
    default ={
        "inbound_s3bucket_a" = "xxx-inbound-bootstrap-bucket-a"
        "inbound_s3bucket_b" = "xxx-inbound-bootstrap-bucket-b"
        "outbound_s3bucket_a" = "xxx-outbound-bootstrap-bucket-a"
        "outbound_s3bucket_b" = "xxx-outbound-bootstrap-bucket-b"
        "east_west_s3bucket_a" = "xxx-east-west-bootstrap-bucket-a"
        "east_west_s3bucket_b" = "xxx-east-west-bootstrap-bucket-b"
    }
}

//**Must Change**
//You will need to enter in authcodes for each of these vm-series firewalls. 
//You may have a single code with multiple copies available and can repeat the authcode if that is the case
variable vm_series_authcodes{
    default = {
        "inbound_s3bucket_a" = ""
        "inbound_s3bucket_b" = ""
        "outbound_s3bucket_a" = ""
        "outbound_s3bucket_b" = ""
       // "east_west_s3bucket_a" = ""
       // "east_west_s3bucket_b" = ""
    }
}

//**Must Change**
variable aws_key {
  description = "aws_key"
  default     = "Oregon Key Pair"
}

//Change according to your IP to access the vm-series management ssh and https UI
//SSH (FW ssh console)  and HTTPS (FW web console) Access IP addresses
//This should be fairly restictive access
variable ssh_https_access_cidr_blocks {
    default = ["0.0.0.0/0"]
}

//**Must Change**
//Panorama Setting which need to be changed accordingly - It is expected that the Panorama is in the same account
//It must be in same account.  If different account you would need to alter this. 
//Used for creating the VPC attachment to the TGW
variable vpc_panorama_managment{
    description = "Management VPC id where Panorama is located."
    default ={
        "vpc_id"     = "vpc-xxxx"
        "subnet_management_id_2a" = "subnet-xxxx"
        "subnet_management_id_2b" = "subnet-xxxx"
        "panorama_management_route_table" = "rtb-xxxxx"
        "panorama_sg" = "sg-xxxxx"

    }
}

//**Must Change**
//This is informaton specific to Panorama for updating the template variables after everything is setup
variable primary_panorama{
    description = "Primary Panorama Information"
    default ={
        "ip" = "x.x.x.x"
        "api_key" = ""

    }
}

//** May Change**?
//This is the preshared key used to create the VPN attachements 
//for both the Outbound VPN Gateways and E/W VPN Gateways
//*****IF THIS IS CHANGED THEN IT MUST BE CHANGED IN THE PANORAMA CONFIGURATION AS WELL******
variable pre_sharedkey{
    default = "TGWrefArch"
}


variable aws_region {
  description = "AWS Region for deployment"
  default     = "us-west-2"
}

variable fw_instance_type {
  default = "m5.xlarge"
}

//Change according to your license type
variable ngfw_license_type {
  default = "byol"
}

//Change according to the vm-series version required
variable ngfw_version {
  default = "9.1.3"
}

//May need to change if creating webserver instance fails with unknown ami id
//It must be an Amazon Linux 2 ami
variable amazon_linux_2_ami_id{
    default = "ami-0b1e2eeb33ce3d66f"
    }


//Build Switches for debug
variable build_inbound_switch {
    default = 0
}

//////////////////DON NOT CHANGE BELOW THIS LINK///////////////////////////////////////////////
//AZ for the set region
data "aws_availability_zones" "available" {
  state = "available"
}

//1.1 Spoke VPCs variables
variable web_vpc {
    description         = "Example VPC for web servers"

    default = {
    "cidr"                = "10.104.0.0/16"
    "vpc_name"            = "TGW_Web"
    "edit_dns_hostnames"  = "true"
    }
    
}

variable db_vpc {
    description        = "Example VPC for db servers"
    default = {
    "cidr"               = "10.105.0.0/16"
    "vpc_name"           = "TGW_DB"
    "edit_dns_hostnames" = "true"
    }
}

//1.2 Create IP Subnets for the Spoke VPCs variables

variable Web_server_2a_subnet {
  
    default =  {
    "subnet_name"           = "TGW_Web-server-2a"
    "cidr"                  = "10.104.0.0/24"
    }
}

variable Web_server_2b_subnet {
    default =  {
    "subnet_name"           = "TGW_Web-server-2b"
    "cidr"                  = "10.104.1.0/24"
    }
}

variable DB_2a_subnet {
    default = {
    "subnet_name"           = "TGW_DB-2a"
    "cidr"                  = "10.105.0.0/24"
     }
}

variable DB_2b_subnet {
    default = {
    "subnet_name"           = "TGW_DB-2b"
    "cidr"                  = "10.105.1.0/24"
    }
}

//1.3 Create Security Groups for the Spoke VPCs
variable  web_private_sg{
    default = {
    "sg_name"               = "TGW_Web-Private"
    "sg_description"        = "Allow inbound traffic from private networks"
    }
}

variable  db_private_sg{
    default = {
    "sg_name"               = "TGW_DB-Private"
    "sg_description"        = "Allow inbound traffic from private networks"
    }
}

//1.4 Create a Transit Gateway

variable TGW{
    default = {
        "name" = "TGW_TGW"
        "description" = "Transit Gateway"
        
    }
}

//1.5 Create Transit Gateway Route Tables
//1.6 Create Transit Gateway Attachments
//1.7 Associate Attachments to the Route Tables
//1.8 Create Spoke VPC Route Tables
//1.9 Modify Management VPC Routes and Security Group

//3.1 Create the VPC  
//******This deviates from the TGW documentation which has the cidr as 10.100.0.0 to accomoadte having the Single VPC model which uses the same cidr block
//in the same Panorama
variable inbound_vpc {
    description         = "Inbound FW VPC"

    default = {
    "cidr"                  = "10.103.0.0/16"
    "vpc_name"              = "TGW_Inbound_Security"
    "edit_dns_hostnames"    = "true"
    "Inbound_Public_2a"     = "10.103.0.0/24"
    "Inbound_FW_2a"         = "10.103.1.0/24"
    "Inbound_TGW_2a"        = "10.103.2.0/24"
    "Inbound_Mgmt_2a"       = "10.103.127.0/24"
    "Inbound_Public_2b"     = "10.103.128.0/24"
    "Inbound_FW_2b"         = "10.103.129.0/24"
    "Inbound_TGW_2b"        = "10.103.130.0/24"
    "Inbound_Mgmt_2b"       = "10.103.255.0/24"
    "Inbound_Public_2a_name"    = "TGW_Inbound-Public-2a"
    "Inbound_FW_2a_name"        = "TGW_Inbound-FW-2a"
    "Inbound_TGW_2a_name"       = "TGW_Inbound-TGW-2a"
    "Inbound_Mgmt_2a_name"      = "TGW_Inbound-Mgmt-2a"
    "Inbound_Public_2b_name"    = "TGW_Inbound-Public-2b"
    "Inbound_FW_2b_name"        = "TGW_Inbound-FW-2b"
    "Inbound_TGW_2b_name"       = "TGW_Inbound-TGW-2b"
    "Inbound_Mgmt_2b_name"       = "TGW_Inbound-Mgmt-2b"
}
}

//3.3 Create a VPC Internet Gateway
//3.4 Create Transit Gateway Attachments
//3.5 Associate Attachments to the Route Tables
//3.6 Create VPC Route Tables

//3.7 Create Security Groups
variable  inboud_fw_public_sg{
    default = {
    "sg_name"               = "TGW_Inbound-Firewall-Public"
    "sg_description"        = "Allow inbound applications from the internet"
    }
}

variable  inboud_fw_mgmt_sg{
    default = {
    "sg_name"               = "TGW_Inbound-Firewall-Mgmt"
    "sg_description"        = "Allow inbound management to the firewall"
    }
}

variable  inboud_fw_private_sg{
    default = {
    "sg_name"               = "TGW_Inbound-Firewall-Private"
    "sg_description"        = "Allow inbound traffic to private interface"
    }
}



//4.1 Create the VM-Series Firewalls
variable inbound_vmseries_a {
    
    default = {
    "managment_ip_address"      = "10.103.127.10"
    "private_ip_address"        = "10.103.1.10"
    "public_ip_address"         = "10.103.0.10"
    "namee"                      = "TGW_inbound-vmseries-a"
    }
}

variable inbound_vmseries_b {
    
    default = {
    "managment_ip_address"      = "10.103.255.10"
    "private_ip_address"        = "10.103.129.10"
    "public_ip_address"         = "10.103.128.10"
    "namee"                      = "TGW_inbound-vmseries-b"
    }
}

//4.2 Create Elastic Network Interfaces for the VM-Series Firewalls
//4.3 Attach the Interfaces to the Firewalls
//4.4 Label the Primary Interfaces for the VM-Series Instance
//4.5 Create Elastic IP Addresses for the VM-Series Firewall
//4.6 Log in to the VM-Series Firewall
//4.7 License the VM-Series Firewalls


//  7.1 Configure the Public Application Load Balancer
variable inbound_http_alb{
    default = {
        "name" = "TGW-ExampleApplication-ALB"
    }
}

//  7.2 Configure the NAT Policy
//  7.3 Enable the XFF and URL Profile
//  7.4 Configure the Security Policy
//  7.5 Locate the Inbound Load-Balancer DNS Name

# 8.1 Create the VPC
variable outbound_vpc {
    description         = "Outbound FW VPC"

    default = {
    "cidr"                  = "10.101.0.0/16"
    "vpc_name"              = "TGW_Outbound_Security"
    "edit_dns_hostnames"    = "true"
       
    "Outbound_Public_2a"        = "10.101.0.0/24"
    "Outbound_TGW_2a"           = "10.101.1.0/24"
    "Outbound_Mgmt_2a"          = "10.101.127.0/24"
    "Outbound_Public_2b"        = "10.101.128.0/24"
    "Outbound_TGW_2b"       = "10.101.129.0/24"
    "Outbound_Mgmt_2b"     = "10.101.255.0/24"

    "Outbound_Public_2a_name"   = "TGW_Outbound-Public-2a"
    "Outbound_TGW_2a_name"      = "TGW_Outbound-TGW-2a"
    "Outbound_Mgmt_2a_name"     = "TGW_Outbound-Mgmt-2a"
    "Outbound_Public_2b_name"   = "TGW_Outbound-Public-2b"
    "Outbound_TGW_2b_name"       = "TGW_Outbound-TGW-2b"
    "Outbound_Mgmt_2b_name"     = "TGW_Outbound-Mgmt-2b"

    }
}
# 8.2 Create IP Subnets
# 8.3 Create a VPC Internet Gateway
# 8.4 Create the Transit Gateway Attachment
# 8.5 Associate Attachments to the Route Tables
# 8.6 Create VPC Route Tables
# 8.7 Create Security Groups

# 9.1 Create the VM-Series Firewalls

variable outbound_vmseries_a {
    
    default = {
    "managment_ip_address"      = "10.101.127.10"
    "public_ip_address"         = "10.101.0.10"
    "namee"                      = "TGW_outbound-vmseries-a"
    }
}

variable outbound_vmseries_b {
    
    default = {
    "managment_ip_address"      = "10.101.255.10"
    "public_ip_address"         = "10.101.128.10"
    "namee"                      = "TGW_outbound-vmseries-b"
    }
}
# 9.2 Create Elastic Network Interfaces for the VM-Series Firewalls
# 9.3 Attach the Interfaces to the Firewalls
# 9.4 Label the Primary Interfaces for the VM-Series Instance
# 9.5 Create Elastic IP Addresses for the VM-Series Firewall
# 9.6 Log in to the VM-Series Firewall
# 9.7 License the VM-Series Firewalls


# 10.1 Create Customer Gateways
variable outbound_customer_gateway_vpn_attachements {
    default ={
        "name_a"   = "TGW_outbound-vmseries-a"
        "tunnel_cidr_a1" = "169.254.0.4/30"
        "tunnel_cidr_a2" = "169.254.0.8/30"
        
        "name_b"   = "TGW_outbound-vmseries-b"
        "tunnel_cidr_b1" = "169.254.0.12/30"
        "tunnel_cidr_b2" = "169.254.0.16/30"

        "bgp" = "65254"
        "route" = "0.0.0.0/0"
        
    }
}
# 10.2 Create Transit Gateway VPN Attachments
# 10.3 Associate Attachments to the Route Tables
# 10.4 Record the Outside IP Address of the VPN Tunnels 



variable ew_vpc {
    description         = "EW FW VPC"

    default = {
    "cidr"                = "10.102.0.0/16"
    "vpc_name"            = "TGW_EW"
    "edit_dns_hostnames"  = "true"
    }
}

# 13.10 Configure Variable Values
variable outbound_template_stacks{
    default = {
        "stack_outbound_a"              = "TGW_Outbound-a-Stack"
        "stack_outbound_b"              = "TGW_Outbound-b-Stack"
    }
}
////////////////////////////////////////////////////////////
//This section should be verified and modified accordingly.
////////////////////////////////////////////////////////////
variable primary_panorama{
    description = "Primary Panorama Information"
    default ={
        "ip" = "x.x.x.x"
        "api_key" = "XXXXXX"

    }
}

#####################################DO NOT ALTER BELOW VARIABLES#############################

# 3.1 Configure Device Groups
 variable device_groups{
     default = {
        "baseline"      = "TGW_AWS-Baseline"
        "inbound"       = "TGW_AWS-Inbound"
        "outbound"      = "TGW_AWS-Outbound"
     }
 }

# 3.3 Create Templates

variable templates{
    default = {
        "baseline"                      = "TGW_Baseline-VMSeries-Settings"
        "inbound"                       = "TGW_Inbound-Network-Settings"
        "ew"                            = "TGW_OBEW-Network-Settings"
        "stack_inbound_a"               = "TGW_Inbound-a-Stack"
        "stack_inbound_b"               = "TGW_Inbound-b-Stack"
        "stack_outbound_a"              = "TGW_Outbound-a-Stack"
        "stack_outbound_b"              = "TGW_Outbound-b-Stack"
        
    }
}
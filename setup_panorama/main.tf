/* This terraform template only creates the stub device group and templates for loading the singlevpc_pan_file.xml configuration */


# 3.1 Configure Device Groups
resource "panos_panorama_device_group" "baseline" {
    name = var.device_groups.baseline
}

resource "panos_panorama_device_group" "inbound" {
    name = var.device_groups.inbound
}

resource "panos_panorama_device_group" "outbound" {
    name = var.device_groups.outbound
}


# 3.3 Create Templates
resource "panos_panorama_template" "baseline" {
    name = var.templates.baseline
    
}

resource "panos_panorama_template" "inbound" {
    name = var.templates.inbound
    
}

resource "panos_panorama_template" "outbound" {
    name = var.templates.ew
    
}

resource "panos_panorama_template_stack" "stack_inbound_a" {
    name = var.templates.stack_inbound_a
    templates = ["${panos_panorama_template.baseline.name}","${panos_panorama_template.inbound.name}"]
}

resource "panos_panorama_template_stack" "stack_inbound_b" {
    name = var.templates.stack_inbound_b
    templates = ["${panos_panorama_template.baseline.name}","${panos_panorama_template.inbound.name}"]
}

resource "panos_panorama_template_stack" "stack_outbound_a" {
    name = var.templates.stack_outbound_a
    templates = ["${panos_panorama_template.baseline.name}","${panos_panorama_template.outbound.name}"]
}

resource "panos_panorama_template_stack" "stack_outbound_b" {
    name = var.templates.stack_outbound_b
    templates = ["${panos_panorama_template.baseline.name}","${panos_panorama_template.outbound.name}"]
}

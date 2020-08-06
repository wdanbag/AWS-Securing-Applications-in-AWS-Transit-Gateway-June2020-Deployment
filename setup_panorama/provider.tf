provider "panos" {
    hostname = var.primary_panorama.ip
    api_key = var.primary_panorama.api_key
}
# Configure the DNS Provider
provider "dns" {
  update {
    server        = "192.168.0.1"
    key_name      = "example.com."
    key_algorithm = "hmac-md5"
    key_secret    = "key_secret"
  }
}

variable "arecords" {
  type    = list(string)
  default = [
    "192.168.0.1",
    "192.168.0.2",
    "192.168.0.3",
  ]
}

# Create a DNS A record set
resource "dns_a_record_set" "www" {
  zone = "example.com."
  name = "www"
  addresses = var.arecords
  ttl = 300
}

# NOTE: Uncomment below for the "Multiple resources based on arrays" section
# Create many DNS A records
resource "dns_a_record_set" "www-multi" {
  count = length(var.arecords)
  zone = "example.com."
  name = "web-0${count.index}"
  addresses = [var.arecords[count.index]]
  ttl = 300
}

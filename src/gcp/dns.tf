# Define Cloud DNS resources.
# https://cloud.google.com/dns

# A managed zone is a container that holds information about how
# you want to route traffic for a domain, such as example.com,
# and its subdomains.
# https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html
resource "google_dns_managed_zone" "domain" {
  # The DNS name of this managed zone, for instance "example.com".
  dns_name = "${var.domain}."

  # User assigned name for this resource.
  # Must be unique within the project.
  name = "terraform-dns-domain"
}

# https://www.terraform.io/docs/providers/google/r/dns_record_set.html
resource "google_dns_record_set" "A" {
  # Name of your managed DNS zone.
  managed_zone = google_dns_managed_zone.domain.name

  # The DNS name this record set will apply to.
  name = google_dns_managed_zone.domain.dns_name

  # The record type. Valid values are A, AAAA, CAA, CNAME, MX, NAPTR,
  #   NS, PTR, SOA, SPF, SRV and TXT.
  type = "A"

  # The time-to-live of this record set (seconds).
  ttl = 86400

  # The string data for the records in this record set
  rrdatas = [google_compute_global_address.cdn.address]
}

resource "google_dns_record_set" "CNAME" {
  count = length(var.alias_domains)

  managed_zone = google_dns_managed_zone.domain.name

  name    = "${var.alias_domains[count.index]}."
  type    = "CNAME"
  rrdatas = [google_dns_managed_zone.domain.dns_name]
  ttl     = 86400
}

output "name_servers" {
  value       = google_dns_managed_zone.domain.name_servers
  description = "Use these custom name servers for your domain."
}

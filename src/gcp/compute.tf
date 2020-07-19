# Define Google Compute resources.

# https://www.terraform.io/docs/providers/google/r/compute_backend_bucket.html
resource "google_compute_backend_bucket" "cdn" {
  # Cloud Storage bucket name.
  bucket_name = google_storage_bucket.domain.name

  # Name of the resource.
  name = "cdn-backend-bucket"

  # An optional textual description of the resource.
  description = "Terraform managed backend bucket for serving static content through CDN."

  # Enable Cloud CDN for this BackendBucket.
  enable_cdn = true
}

# https://www.terraform.io/docs/providers/google/r/compute_url_map.html
resource "google_compute_url_map" "cdn" {
  # Name of the resource.
  name = "cdn-url-map"

  # An optional description of this resource.
  description = "Terraform managed CDN URL map."

  # The backend bucket to use when none of the given rules match.
  default_service = google_compute_backend_bucket.cdn.self_link
}

# https://www.terraform.io/docs/providers/google/r/compute_managed_ssl_certificate.html
resource "google_compute_managed_ssl_certificate" "cdn" {
  # Name of the resource.
  name = "cdn-ssl-certificate"

  provider = google-beta

  # Properties relevant to a managed certificate.
  managed {
    domains = concat([var.domain], var.alias_domains)
  }
}

# https://www.terraform.io/docs/providers/google/r/compute_target_https_proxy.html
resource "google_compute_target_https_proxy" "cdn" {
  # Name of the resource.
  name = "cdn-https-proxy"

  # A reference to the UrlMap resource.
  url_map = google_compute_url_map.cdn.self_link

  # A list of SslCertificate resources.
  ssl_certificates = [google_compute_managed_ssl_certificate.cdn.self_link]
}

# https://www.terraform.io/docs/providers/google/r/compute_global_address.html
resource "google_compute_global_address" "cdn" {
  # Name of the resource.
  name = "cdn-global-address"

  # The IP Version that will be used by this address.
  ip_version = "IPV4"

  # The IP address or beginning of the address range represented by this resource.
  address_type = "EXTERNAL"
}

# $0.025 * 24 hours * 30 days = $18 per month! AWS pricing is better (FREE).
# https://www.terraform.io/docs/providers/google/r/compute_global_forwarding_rule.html
resource "google_compute_global_forwarding_rule" "cdn" {
  # Name of the resource.
  name = "cdn-global-forwarding-rule"

  # The URL of the target resource to receive the matched traffic.
  target = google_compute_target_https_proxy.cdn.self_link

  # The IP address that this forwarding rule is serving on behalf of.
  ip_address = google_compute_global_address.cdn.address

  # Specify port range.
  port_range = "443"
}

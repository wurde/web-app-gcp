# Configure resources.

module "gcp" {
  source = "./src/gcp"

  dist_dir          = var.dist_dir
  domain            = var.domain
  alias_domains     = var.alias_domains
  default_ttl       = var.default_ttl
  country_blacklist = var.country_blacklist
}

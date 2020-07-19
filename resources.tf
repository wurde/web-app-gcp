# Configure resources.

module "aws" {
  count  = var.cloud == "aws" ? 1 : 0
  source = "./src/aws"

  dist_dir          = var.dist_dir
  domain            = var.domain
  alias_domains     = var.alias_domains
  default_ttl       = var.default_ttl
  country_blacklist = var.country_blacklist
}

module "gcp" {
  count  = var.cloud == "gcp" ? 1 : 0
  source = "./src/gcp"

  dist_dir          = var.dist_dir
  domain            = var.domain
  alias_domains     = var.alias_domains
  default_ttl       = var.default_ttl
  country_blacklist = var.country_blacklist
}

module "netlify" {
  count  = var.cloud == "netlify" ? 1 : 0
  source = "./src/netlify"

  dist_dir  = var.dist_dir
  repo_path = var.repo_path
  command   = var.command
}

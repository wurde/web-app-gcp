# Web Application

Terraform module for deploying a web application to GCP.
This module assumes an app deployed using pre-rendered
static assets distributed via global content delivery
network.

## Consider this first

Prefer a managed solution over custom code. Before exploring
the Terraform option, consider the alternatives that'll
save time and money. Consider these solutions first:

- [Firebase](https://firebase.google.com) by Google.
- [Amplify](https://aws.amazon.com/amplify) by AWS.
- [Netlify](https://www.netlify.com)
- [GitHub Pages](https://pages.github.com)

Reasons why this module is a good candidate:

- Infrastructure is already managed by Terraform.
- Requirement for a cloud-agnostic IaC solution.

## Getting started

Example usage within a Terraform configuration:

```terraform
module "static-website" {
  source = "github.com/wurde/web-app-gcp"

  dist_dir      = "./dist"
  domain        = "example.com"
  alias_domains = ["www.example.com"]
}
```

Next run `terraform apply`. Or automate via CI/CD pipelines
(GitHub Actions?).

A necessary manual step is adding the custom DNS name
servers to your domain name provider (Google Domains?).
This enables domain ownership verification.

Example name servers provided by GCP:

    ns-cloud-x1.googledomains.com.
    ns-cloud-x2.googledomains.com.
    ns-cloud-x3.googledomains.com.
    ns-cloud-x4.googledomains.com.

## Pricing Estimate

**~20 dollars a month.**
Primary charges are Global Forwarding Rules.

## Why Terraform?

Terraform enables Infrastructure as Code.
[Learn more about it here](https://www.terraform.io).

## License

This project is __FREE__ to use, reuse, remix, and resell.
This is made possible by the [MIT license](/LICENSE).

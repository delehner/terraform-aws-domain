# Terraform - Domain Module

This Terraform module provides Route53 and Certificate Manager features to help you manage domains and SSL/TLS certificates.

## Usage

Here's a code example of how you can use this module:

```hcl
module "my_domain" {
  source  = "app.terraform.io/<organization>/domain/aws"
  version = "~> 1"

  domain = "my_domain.com"
  new_domain = true
}
```

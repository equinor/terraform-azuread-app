# Terraform module for Microsoft Entra ID Application

Terraform module which creates Microsoft Entra ID (previously Azure Active Directory) Application resources.

## Features

- Registers an application in Microsoft Entra ID.
- Creates a corresponding Microsoft Entra ID service principal.
- Adds an identifier URI by default.
- Service management reference enforced (e.g. ServiceNow App ID).
- Minimum two owners enforced.

## Prerequisites

- Microsoft Entra role `Application Developer` at the tenant scope.

## Usage

```terraform
provider "azuread" {}

data "azuread_user" "foo" {
  user_principal_name = "foo@example.com"
}

data "azuread_user" "bar" {
  user_principal_name = "bar@example.com"
}

module "app" {
  source  = "equinor/app/azuread"
  version = "~> 0.10"

  application_display_name     = "example-app"
  service_management_reference = "12345"
  owners = [
    data.azuread_user.foo.object_id,
    data.azuread_user.bar.object_id
  ]
}
```

## Contributing

See [Contributing guidelines](https://github.com/equinor/terraform-baseline/blob/main/CONTRIBUTING.md).

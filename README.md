# Terraform module for Microsoft Entra ID Application

[![GitHub Release](https://img.shields.io/github/v/release/equinor/terraform-azuread-app)](https://github.com/equinor/terraform-azuread-app/releases/latest)
[![Terraform Module Downloads](https://img.shields.io/terraform/module/dt/equinor/app/azuread)](https://registry.terraform.io/modules/equinor/app/azuread/latest)
[![GitHub contributors](https://img.shields.io/github/contributors/equinor/terraform-azuread-app)](https://github.com/equinor/terraform-azuread-app/graphs/contributors)
[![GitHub Issues](https://img.shields.io/github/issues/equinor/terraform-azuread-app)](https://github.com/equinor/terraform-azuread-app/issues)
[![GitHub Pull requests](https://img.shields.io/github/issues-pr/equinor/terraform-azuread-app)](https://github.com/equinor/terraform-azuread-app/pulls)
[![GitHub License](https://img.shields.io/github/license/equinor/terraform-azuread-app)](https://github.com/equinor/terraform-azuread-app/blob/main/LICENSE)

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
  version = "~> 0.9"

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

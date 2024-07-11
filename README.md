# Microsoft Entra ID application Terraform module

[![SCM Compliance](https://scm-compliance-api.radix.equinor.com/repos/equinor/terraform-azuread-app/badge)](https://scm-compliance-api.radix.equinor.com/repos/equinor/terraform-azuread-app/badge)
[![Equinor Terraform Baseline](https://img.shields.io/badge/Equinor%20Terraform%20Baseline-1.0.0-blueviolet)](https://github.com/equinor/terraform-baseline)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)

Terraform module which creates a Microsoft Entra ID application.

## Features

- Minimum two owners enforced.
- Service management reference enforced.
- Identifier URI added by default.
- Corresponding Microsoft Entra service principal automatically created.

## Development

1. Clone this repository:

    ```console
    git clone https://github.com/equinor/terraform-azuread-app.git
    ```

1. Login to Microsoft Entra ID:

    ```console
    az login --allow-no-subscriptions
    ```

## Contributing

See [Contributing guidelines](https://github.com/equinor/terraform-baseline/blob/main/CONTRIBUTING.md).

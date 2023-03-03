provider "azuread" {
  features {}
}

resource "random_id" "example" {
  byte_length = 8
}

module "sp" {
  # source = "github.com/equinor/terraform-azuread-sp"
  source = "../.."

  display_name = "sp-${random_id.example.hex}"

  federated_identity_credentials = {
    "example" = {
      display_name = "github-actions"
      issuer       = "https://token.actions.githubusercontent.com"
      subject      = "repo:equinor/terraform-azuread-sp:environment:dev"
    }
  }
}

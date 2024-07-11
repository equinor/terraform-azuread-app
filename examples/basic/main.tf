provider "azuread" {}

resource "random_id" "example" {
  byte_length = 8
}

data "azuread_client_config" "current" {}

module "app" {
  source  = "equinor/app/azuread"
  version = "0.2.0"

  display_name                 = "app-${random_id.example.hex}"
  service_management_reference = "12345"

  owners = concat([data.azuread_client_config.current.object_id], var.owners)
}

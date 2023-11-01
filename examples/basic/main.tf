provider "azuread" {}

data "azuread_client_config" "current" {}

resource "random_id" "example" {
  byte_length = 8
}

module "app" {
  # source = "github.com/equinor/terraform-azuread-app"
  source = "../.."

  display_name                 = "app-${random_id.example.hex}"
  service_management_reference = "12345"

  owners = [
    data.azuread_client_config.current.object_id,
    "00000000-0000-0000-0000-000000000000" # example object ID
  ]
}

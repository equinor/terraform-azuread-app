data "azuread_client_config" "current" {}

locals {
  # Explicitly add current client to list of owners.
  owners = concat(var.owners, [data.azuread_client_config.current.object_id])
}

resource "azuread_application" "this" {
  display_name = var.display_name
  owners       = local.owners
}

resource "azuread_application_federated_identity_credential" "this" {
  for_each = var.federated_identity_credentials

  application_object_id = azuread_application.this.object_id
  display_name          = each.value["display_name"]
  description           = each.value["description"]
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = each.value["issuer"]
  subject               = each.value["subject"]
}

resource "azuread_service_principal" "this" {
  application_id = azuread_application.this.id
  owners         = local.owners
}

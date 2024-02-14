data "azuread_client_config" "current" {}

resource "azuread_application" "this" {
  display_name                   = var.display_name
  service_management_reference   = var.service_management_reference
  owners                         = var.owners
  device_only_auth_enabled       = var.device_only_auth_enabled
  fallback_public_client_enabled = var.fallback_public_client_enabled
  identifier_uris                = var.identifier_uris
  sign_in_audience               = "AzureADMyOrg"

  lifecycle {
    precondition {
      condition     = contains(var.owners, data.azuread_client_config.current.object_id)
      error_message = "Current client (object ID: \"${data.azuread_client_config.current.object_id}\") must be set as owner."
    }
  }
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
  owners    = var.owners
  login_url = var.login_url
}

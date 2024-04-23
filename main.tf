data "azuread_client_config" "current" {}

# Azure Active Directory provider version 2.44.0 adds a new simplified resource "azuread_application_registration" for
# creating applications, however that resource requires configuration of owners using a separate resource
# "azuread_application_owner". This means that the initial application will be created without any owners, which means
# that you'll need Entra ID role "Application Administrator" or "Global Administrator" to make further changes to the
# application (including configuring yourself as owner).
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

locals {
  identifier_uris = {
    # Set default identifier URI.
    # Ref: https://learn.microsoft.com/en-us/entra/identity-platform/reference-app-manifest#identifieruris-attribute
    "default" = "api://${azuread_application.this.client_id}"
  }
}

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
  sign_in_audience               = "AzureADMyOrg"

  public_client {
    redirect_uris = var.public_client_redirect_uris
  }

  web {
    homepage_url  = var.web_homepage_url
    logout_url    = var.web_logout_url
    redirect_uris = var.web_redirect_uris

    implicit_grant {
      access_token_issuance_enabled = var.access_token_issuance_enabled
      id_token_issuance_enabled     = var.id_token_issuance_enabled
    }
  }

  dynamic "required_resource_access" {
    for_each = var.required_resource_accesses

    content {
      resource_app_id = required_resource_access.value.resource_app_id

      dynamic "resource_access" {
        for_each = required_resource_access.value.resource_accesses

        content {
          id   = resource_access.value.id
          type = resource_access.value.type
        }
      }
    }
  }

  api {
    dynamic "oauth2_permission_scope" {
      for_each = var.oauth2_permission_scopes

      content {
        admin_consent_description  = oauth2_permission_scope.value.admin_consent_description
        admin_consent_display_name = oauth2_permission_scope.value.admin_consent_display_name

        enabled = oauth2_permission_scope.value.enabled
        id      = random_uuid.oauth2_permission_scope[oauth2_permission_scope.key].result
        type    = oauth2_permission_scope.value.type

        user_consent_description  = oauth2_permission_scope.value.user_consent_description
        user_consent_display_name = oauth2_permission_scope.value.user_consent_display_name

        value = oauth2_permission_scope.value.value
      }
    }
  }

  lifecycle {
    ignore_changes = [
      # Configure identifier URIs using the standalone "azuread_application_identifier_uri" resource instead.
      # This is required in order for the identifier URIs to reference the properties of the application, typically its application (client) ID.
      identifier_uris
    ]

    precondition {
      condition     = contains(var.owners, data.azuread_client_config.current.object_id)
      error_message = "Current client (object ID: \"${data.azuread_client_config.current.object_id}\") must be set as owner."
    }
  }
}

resource "random_uuid" "oauth2_permission_scope" {
  count = length(var.oauth2_permission_scopes)
}

resource "azuread_application_identifier_uri" "this" {
  for_each = merge(local.identifier_uris, var.identifier_uris)

  application_id = azuread_application.this.id
  identifier_uri = each.value
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
  owners    = var.owners
  login_url = var.login_url
}

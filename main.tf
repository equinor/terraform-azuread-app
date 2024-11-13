data "azuread_client_config" "current" {}

# Azure Active Directory provider version 2.44.0 adds a new simplified resource "azuread_application_registration" for
# creating applications, however that resource requires configuration of owners using a separate resource
# "azuread_application_owner". This means that the initial application will be created without any owners, which means
# that you'll need Entra ID role "Application Administrator" or "Global Administrator" to make further changes to the
# application (including configuring yourself as owner).
resource "azuread_application" "this" {
  display_name                   = var.application_display_name
  service_management_reference   = var.service_management_reference
  owners                         = var.owners
  device_only_auth_enabled       = var.device_only_auth_enabled
  fallback_public_client_enabled = var.fallback_public_client_enabled
  sign_in_audience               = "AzureADMyOrg"
  group_membership_claims        = var.group_membership_claims
  notes                          = var.notes
  description                    = var.description

  public_client {
    redirect_uris = var.public_client_redirect_uris
  }

  dynamic "app_role" {
    for_each = var.app_roles

    content {
      allowed_member_types = app_role.value.allowed_member_types
      description          = app_role.value.description
      display_name         = app_role.value.display_name
      enabled              = app_role.value.enabled
      id                   = random_uuid.app_role[app_role.key].result
      value                = app_role.value.value
    }
  }

  web {
    homepage_url  = var.web_homepage_url
    logout_url    = var.web_logout_url
    redirect_uris = var.web_redirect_uris

    implicit_grant {
      access_token_issuance_enabled = var.web_implicit_grant_access_token_issuance_enabled
      id_token_issuance_enabled     = var.web_implicit_grant_id_token_issuance_enabled
    }
  }

  single_page_application {
    redirect_uris = var.single_page_application_redirect_uris
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
    known_client_applications      = var.api_known_client_applications
    requested_access_token_version = var.api_requested_access_token_version
    mapped_claims_enabled          = var.api_mapped_claims_enabled

    dynamic "oauth2_permission_scope" {
      for_each = var.api_oauth2_permission_scopes

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

  optional_claims {
    dynamic "access_token" {
      for_each = var.optional_claims_access_token

      content {
        additional_properties = access_token.value.additional_properties
        essential             = access_token.value.essential
        name                  = access_token.value.name
        source                = access_token.value.source
      }
    }

    dynamic "id_token" {
      for_each = var.optional_claims_id_token

      content {
        additional_properties = id_token.value.additional_properties
        essential             = id_token.value.essential
        name                  = id_token.value.name
        source                = id_token.value.source
      }
    }

    dynamic "saml2_token" {
      for_each = var.optional_claims_saml2_token

      content {
        additional_properties = saml2_token.value.additional_properties
        essential             = saml2_token.value.essential
        name                  = saml2_token.value.name
        source                = saml2_token.value.source
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
  // Generate random UUIDs for each permission scope
  for_each = var.api_oauth2_permission_scopes
}

resource "random_uuid" "app_role" {
  // Generate random UUIDs for each app role
  for_each = var.app_roles
}

resource "azuread_application_identifier_uri" "this" {
  count = var.create_identifier_uri ? 1 : 0

  application_id = azuread_application.this.id
  identifier_uri = "api://${azuread_application.this.client_id}"
  # Ref: https://learn.microsoft.com/en-us/entra/identity-platform/reference-app-manifest#identifieruris-attribute
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
  owners    = var.owners
  login_url = var.login_url
}

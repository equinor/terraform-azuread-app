data "azuread_client_config" "current" {}

resource "azuread_application" "this" {
  display_name                   = var.display_name
  service_management_reference   = var.service_management_reference
  owners                         = var.owners
  device_only_auth_enabled       = var.device_only_auth_enabled
  fallback_public_client_enabled = var.fallback_public_client_enabled
  sign_in_audience               = "AzureADMyOrg"

  public_client {
    redirect_uris = var.public_redirect_uris
  }

  web {
    homepage_url  = var.homepage_url
    logout_url    = var.logout_url
    redirect_uris = var.web_redirect_uris

    implicit_grant {
      access_token_issuance_enabled = var.access_token_issuance_enabled
      id_token_issuance_enabled     = var.id_token_issuance_enabled
    }
  }

  dynamic "required_resource_access" {
    for_each = var.required_resource_access
    content {
      resource_app_id = required_resource_access.value.resource_app_id

      resource_access {
        id   = required_resource_access.value.resource_access.id
        type = required_resource_access.value.resource_access.type
      }
    }
  }

  api {
    dynamic "oauth2_permission_scope" {
      for_each = { for scope in var.oauth2_permission_scopes : scope.value => scope }
      content {
        admin_consent_description  = oauth2_permission_scope.value.admin_consent_description
        admin_consent_display_name = oauth2_permission_scope.value.admin_consent_display_name

        enabled = oauth2_permission_scope.value.enabled
        id      = random_uuid.scope_id[oauth2_permission_scope.key].result
        type    = oauth2_permission_scope.value.type

        user_consent_description  = oauth2_permission_scope.value.user_consent_description
        user_consent_display_name = oauth2_permission_scope.value.user_consent_display_name

        value = oauth2_permission_scope.value.value
      }
    }
  }

  lifecycle {
    precondition {
      condition     = contains(var.owners, data.azuread_client_config.current.object_id)
      error_message = "Current client (object ID: \"${data.azuread_client_config.current.object_id}\") must be set as owner."
    }
    ignore_changes = [
      identifier_uris,
    ]
  }
}

resource "random_uuid" "scope_id" {
  for_each = { for scope in var.oauth2_permission_scopes : scope.value => scope }
}

resource "azuread_application_identifier_uri" "default" {
  application_id = azuread_application.this.id
  identifier_uri = "api://${azuread_application.this.client_id}"
}

resource "azuread_application_identifier_uri" "extra" {
  for_each = var.identifier_uris

  application_id = azuread_application.this.id
  identifier_uri = each.value
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
  owners    = var.owners
  login_url = var.login_url
}

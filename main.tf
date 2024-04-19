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
    logout_url    = var.login_url
    redirect_uris = var.web_redirect_uris

    implicit_grant {
      access_token_issuance_enabled = var.access_token_issuance
      id_token_issuance_enabled     = var.id_token_issuance
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
  for_each = { for scope in var.oauth2_permission_scopes : scope.value => scope}
}

resource "azuread_application_permission_scope" "this" {
  for_each = { for scope in var.oauth2_permission_scopes : scope.value => scope}

  admin_consent_description  = each.value.admin_consent_description
  admin_consent_display_name = each.value.admin_consent_display_name

  application_id = azuread_application.this.id
  scope_id       = random_uuid.scope_id[each.key].result
  type           = each.value.type

  user_consent_description  = each.value.user_consent_description
  user_consent_display_name = each.value.user_consent_display_name

  value = each.value.value
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

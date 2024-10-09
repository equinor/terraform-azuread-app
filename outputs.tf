output "application_id" {
  description = "The ID of this application."
  value       = azuread_application.this.id
}

output "application_object_id" {
  description = "The object ID of this application."
  value       = azuread_application.this.object_id
}

output "application_client_id" {
  description = "The client ID of this application."
  value       = azuread_application.this.client_id
}

output "service_principal_object_id" {
  description = "The object ID of this service principal."
  value       = azuread_service_principal.this.object_id
}

output "api_oauth2_permission_scope_ids" {
  description = "A map of Oauth2 permission scope IDs."
  value = {
    for k, v in azuread_application.this.api[0].oauth2_permission_scope : k => v.id
  }
}

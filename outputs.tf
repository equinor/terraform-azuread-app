output "object_id" {
  description = "The object ID of this application."
  value       = azuread_application.this.object_id
}

output "client_id" {
  description = "The client ID of this application."
  value       = azuread_application.this.client_id
}

output "service_principal_object_id" {
  description = "The object ID of this service principal."
  value       = azuread_service_principal.this.object_id
}

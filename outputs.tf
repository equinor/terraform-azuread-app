output "object_id" {
  description = "The object ID of this service principal."
  value       = azuread_service_principal.this.object_id
}

output "application_id" {
  description = "The application (client) ID of this service principal."
  value       = azuread_service_principal.this.application_id
}

output "tenant_id" {
  description = "The tenant ID of this service principal."
  value       = azuread_service_principal.this.application_tenant_id
}

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azuread = {
      source = "hashicorp/azuread"
      # Version 2.44.0 required to use the "azuread_application_identifier_uri" resource
      version = ">= 2.44.0"
    }
  }
}

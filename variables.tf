variable "display_name" {
  description = "The display name of this application."
  type        = string
}

variable "device_only_auth_enabled" {
  description = "(Optional) Specifies whether this application supports device authentication without a user."
  type        = bool
  default     = false
}

variable "fallback_public_client_enabled" {
  description = " (Optional) Specifies whether the application is a public client. Appropriate for apps using token grant flows that don't use a redirect URI."
  type        = bool
  default     = false
}

variable "identifier_uris" {
  description = "(Optional) A set of user-defined URI(s) that uniquely identify an application within its Azure AD tenant, or within a verified custom domain if the application is multi-tenant."
  type        = set(string)
  default     = []
}

variable "service_management_reference" {
  description = "Reference application context information from a service management datbase, e.g. ServiceNow."
  type        = string
}

variable "owners" {
  description = "A list of object IDs of owners to set for this application. At least two owners must be set."
  type        = list(string)

  validation {
    condition     = length(var.owners) >= 2
    error_message = "At least two owners must be set."
  }
}

variable "login_url" {
  description = "(Optional) The URL where the service provider redirects the user to Azure AD to authenticate. Azure AD uses the URL to launch the application from Microsoft 365 or the Azure AD My Apps. When blank, Azure AD performs IdP-initiated sign-on for applications configured with SAML-based single sign-on."
  type        = string
  default     = null
}

variable "homepage_url" {
  description = "(Optional) Application home page."
  type        = string
  default     = null
}

variable "logout_url" {
  description = "(Optional) The URL that will be used to sign out."
  type        = string
  default     = null
}

variable "web_redirect_uris" {
  description = "(Optional) A set of URLs where OAuth 2.0 autorization codes and access tokens are sent."
  type        = set(string)

  validation {
    condition     = alltrue([for uri in var.web_redirect_uris : can(regex("^https://|^ms-appx-web://|^http://localhost", uri))])
    error_message = "All URIs must be valid HTTPS URLs excluding localhost."
  }

  default = []
}

variable "public_redirect_uris" {
  description = "(Optional) A set of URLs where OAuth 2.0 autorization codes and access tokens are sent."
  type        = set(string)

  validation {
    condition     = alltrue([for uri in var.public_redirect_uris : can(regex("^https://|^ms-appx-web://", uri))])
    error_message = "All URIs must be valid HTTPS or ms-appx-web URLs."
  }

  default = []
}

variable "access_token_issuance" {
  description = "(Optional) Should the application be allowed to request an access token?"
  type        = bool
  default     = false
}

variable "id_token_issuance" {
  description = "(Optional) Should the application be allowed to request an ID token?"
  type        = bool
  default     = false
}

variable "required_resource_access" {
  description = "(Optional) List of required resource access blocks"
  type = list(object({
    resource_app_id = string
    resource_access = object({
      id   = string
      type = string
    })
  }))

  validation {
    condition     = alltrue([for resource in var.required_resource_access : resource.resource_access.type == "Role" || resource.resource_access.type == "Scope"])
    error_message = "Type must be either \"Role\" or \"Scope\""
  }

  default = []
}

variable "oauth2_permission_scopes" {
  description = "(Optional) List of required oauth permission scope"
  type = list(object({
    admin_consent_description  = string
    admin_consent_display_name = string
    enabled                    = bool
    type                       = optional(string)
    user_consent_description   = optional(string)
    user_consent_display_name  = optional(string)
    value                      = optional(string)
  }))

  validation {
    condition     = alltrue([for scope in var.oauth2_permission_scopes : scope.type == "User" || scope.type == "Admin"])
    error_message = "Type must be either \"User\" or \"Admin\""
  }

  default = []
}

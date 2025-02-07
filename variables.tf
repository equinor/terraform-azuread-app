variable "application_display_name" {
  description = "The display name of this application."
  type        = string
}

variable "app_roles" {
  description = "A map of application roles to configure for this application."
  type = map(object({
    allowed_member_types = list(string)
    description          = string
    display_name         = string
    id                   = optional(string)
    enabled              = bool
    value                = string
  }))
  default = {}
}

variable "device_only_auth_enabled" {
  description = "Specifies whether this application supports device authentication without a user."
  type        = bool
  default     = false
}

variable "fallback_public_client_enabled" {
  description = "Specifies whether the application is a public client. Appropriate for apps using token grant flows that don't use a redirect URI."
  type        = bool
  default     = false
}

variable "group_membership_claims" {
  description = "A set of strings containing membership claims issued in a user or OAuth 2.0 access token that the app expects. Possible values are None, SecurityGroup, DirectoryRole, ApplicationGroup or All."
  type        = set(string)
  default     = ["None"]
}

variable "create_identifier_uri" {
  description = "Should an identifier URI be created and added to this application? The identifier URI will uniquely identity this application within its Microsoft Entra ID tenant, or within a verified comain if this application is multi-tenant."
  type        = bool
  default     = false
  nullable    = false
}

variable "api_known_client_applications" {
  description = "A set of object IDs of applications that are pre-authorized to access this application."
  type        = set(string)
  default     = []
}

variable "api_mapped_claims_enabled" {
  description = "Allows an application to use claims mapping without specifying a custom signing key."
  type        = bool
  default     = false
}

variable "service_management_reference" {
  description = "Reference application context information from a service management database, e.g. ServiceNow."
  type        = string
}

variable "login_url" {
  description = "The URL where the service provider redirects the user to Microsoft Entra ID to authenticate."
  type        = string
  default     = null
}

variable "notes" {
  description = "User-specified notes relevant for the management of the application."
  type        = string
  default     = null
}

variable "description" {
  description = "A description of the application, as shown to end users."
  type        = string
  default     = null
}

variable "optional_claims_access_token" {
  description = <<-EOT
  A list of optional access token claims to include in the access token. The object has the following structure:
    `additional_properties` - List of additional properties of the claim. If a property exists in this list, it modifies the behaviour of the optional claim.
    Possible values are: cloud_displayname, dns_domain_and_sam_account_name, emit_as_roles, include_externally_authenticated_upn_without_hash, include_externally_authenticated_upn, max_size_limit, netbios_domain_and_sam_account_name, on_premise_security_identifier, sam_account_name, and use_guid.
    `essential` - Whether the claim specified by the client is necessary to ensure a smooth authorization experience.
    `name` - The name of the optional claim. For predifined optional claims see https://learn.microsoft.com/en-us/entra/identity-platform/optional-claims-reference
    `source` - The source of the claim. If source is absent, the claim is a predefined optional claim. If source is user, the value of name is the extension property from the user object.
  EOT
  type = list(object({
    additional_properties = optional(list(string), null)
    essential             = optional(bool, false)
    name                  = string
    source                = optional(string, null)
  }))
  default = []
}

variable "optional_claims_id_token" {
  description = <<-EOT
  A list of optional ID token claims to include in the ID token. The object has the following structure:
    `additional_properties` - List of additional properties of the claim. If a property exists in this list, it modifies the behaviour of the optional claim.
    Possible values are: cloud_displayname, dns_domain_and_sam_account_name, emit_as_roles, include_externally_authenticated_upn_without_hash, include_externally_authenticated_upn, max_size_limit, netbios_domain_and_sam_account_name, on_premise_security_identifier, sam_account_name, and use_guid.
    `essential` - Whether the claim specified by the client is necessary to ensure a smooth authorization experience.
    `name` - The name of the optional claim. For predifined optional claims see https://learn.microsoft.com/en-us/entra/identity-platform/optional-claims-reference
    `source` - The source of the claim. If source is absent, the claim is a predefined optional claim. If source is user, the value of name is the extension property from the user object.
  EOT
  type = list(object({
    additional_properties = optional(list(string), null)
    essential             = optional(bool, false)
    name                  = string
    source                = optional(string, null)
  }))
  default = []
}

variable "optional_claims_saml2_token" {
  description = <<-EOT
  A list of optional SAML 2.0 token claims to include in the SAML 2.0 token. The object has the following structure:
    `additional_properties` - List of additional properties of the claim. If a property exists in this list, it modifies the behaviour of the optional claim.
    Possible values are: cloud_displayname, dns_domain_and_sam_account_name, emit_as_roles, include_externally_authenticated_upn_without_hash, include_externally_authenticated_upn, max_size_limit, netbios_domain_and_sam_account_name, on_premise_security_identifier, sam_account_name, and use_guid.
    `essential` - Whether the claim specified by the client is necessary to ensure a smooth authorization experience.
    `name` - The name of the optional claim. For predifined optional claims see https://learn.microsoft.com/en-us/entra/identity-platform/optional-claims-reference
    `source` - The source of the claim. If source is absent, the claim is a predefined optional claim. If source is user, the value of name is the extension property from the user object.
  EOT
  type = list(object({
    additional_properties = optional(list(string), null)
    essential             = optional(bool, false)
    name                  = string
    source                = optional(string, null)
  }))
  default = []
}

variable "owners" {
  description = "A list of object IDs of owners to set for this application. At least two owners must be set."
  type        = list(string)

  validation {
    condition     = length(var.owners) >= 2
    error_message = "At least two owners must be set."
  }
}

variable "web_homepage_url" {
  description = "The home or landing page URL of this application."
  type        = string
  default     = null
}

variable "web_logout_url" {
  description = "The URL that will be used by Microsoft's authorization service to sign out a user."
  type        = string
  default     = null
}

variable "web_redirect_uris" {
  description = "A list of URLs where OAuth 2.0 autorization codes and access tokens are sent."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for uri in var.web_redirect_uris : can(regex("^https://|^ms-appx-web://|^http://localhost", uri))])
    error_message = "All URIs must be valid HTTPS URLs excluding localhost."
  }
}

variable "single_page_application_redirect_uris" {
  description = "A list of URLs where OAuth 2.0 autorization codes and access tokens are sent."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for uri in var.single_page_application_redirect_uris : can(regex("^https://|^ms-appx-web://|^http://localhost", uri))])
    error_message = "All URIs must be valid HTTPS URLs excluding localhost."
  }
}

variable "public_client_redirect_uris" {
  description = "A list of URLs where public client (e.g. mobile) OAuth 2.0 autorization codes and access tokens are sent."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for uri in var.public_client_redirect_uris : can(regex("^https://|^ms-appx-web://", uri))])
    error_message = "All URIs must be valid HTTPS or ms-appx-web URLs."
  }
}

variable "web_implicit_grant_access_token_issuance_enabled" {
  description = "Should this application be allowed to request an access token?"
  type        = bool
  default     = false
}

variable "web_implicit_grant_id_token_issuance_enabled" {
  description = "Should this application be allowed to request an ID token?"
  type        = bool
  default     = false
}

variable "api_requested_access_token_version" {
  description = "The access token version to request."
  type        = number
  default     = 2

  validation {
    condition     = var.api_requested_access_token_version == 1 || var.api_requested_access_token_version == 2
    error_message = "The requested access token version must be either 1 or 2."
  }
}

variable "required_resource_accesses" {
  description = "A list of required resource accesses to configure for this application."
  type = list(object({
    resource_app_id = string
    resource_accesses = list(object({
      id   = string
      type = string
    }))
  }))
  default = []

  validation {
    condition     = alltrue([for resource in var.required_resource_accesses : alltrue([for access in resource.resource_accesses : access.type == "Role" || access.type == "Scope"])])
    error_message = "Type must be either \"Role\" or \"Scope\"."
  }
}

variable "api_oauth2_permission_scopes" {
  description = "A list of required OAuth 2.0 permission scopes to configure for this application."
  # Since the primary use of this variable is the creation of a dynamic nested
  # block "azuread_application.this.api[0].oauth2_permission_scope", we'd
  # usually set the type to 'list(object)'. However, this variable will also be
  # used to create a repeatable resource 'random_uuid.oauth2_permission_scope'
  # using the 'for_each' meta-argument, and with the 'for_each' meta-argument
  # it's safer to use a map as an input. Using a list, changes to its contents
  # could lead to a change of indexes, effectively changing Terraform resource
  # identifiers and requiring those resources to be re-created.
  type = map(object({
    admin_consent_description  = string
    admin_consent_display_name = string
    enabled                    = bool
    id                         = optional(string)
    type                       = string
    user_consent_description   = optional(string)
    user_consent_display_name  = optional(string)
    value                      = optional(string)
  }))
  default = {}

  validation {
    condition     = alltrue([for scope in var.api_oauth2_permission_scopes : scope.type == "User" || scope.type == "Admin"])
    error_message = "Type must be either \"User\" or \"Admin\"."
  }
}

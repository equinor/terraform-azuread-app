variable "display_name" {
  description = "The display name of this service principal."
  type        = string
}

variable "service_management_reference" {
  description = "Reference application context information from a service management datbase, e.g. ServiceNow."
  type        = string
}

variable "owners" {
  description = "A list of owners to set for this service principal. Current client will be added by default."
  type        = list(string)
  default     = []
}

variable "federated_identity_credentials" {
  description = "A map of federated identity credentials to create for this service principal."

  type = map(object({
    display_name = string
    description  = optional(string, "")
    issuer       = string
    subject      = string
  }))

  default = {}
}

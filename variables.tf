variable "display_name" {
  description = "The display name of this service principal."
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
    audiences    = optiona(list(string), ["api://AzureADTokenExchange"])
    issuer       = optional(string, "https://token.actions.githubusercontent.com")
    subject      = string
  }))

  default = {}
}

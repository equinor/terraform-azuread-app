variable "display_name" {
  description = "The display name of this application."
  type        = string
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

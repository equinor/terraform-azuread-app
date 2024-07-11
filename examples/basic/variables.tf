variable "owners" {
  description = "A list of object IDs of owners to set for this application."
  type        = list(string)
  nullable    = false
}

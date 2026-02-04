variable "domain" {
  type        = string
  description = "The domain for the hosted zone."
}

variable "new_domain" {
  type        = bool
  default     = false
  description = "When marked as true, will create a new hosted zone for the domain."
}

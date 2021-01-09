variable "fqdn" {
  description = "FQDN for the hosted zone"
  type        = string
  default     = "integrable.systems."
}

variable "ttl" {
  description = "TTL for general records"
  type        = number
  default     = 600
}

variable "www_cname_records" {
  description = "Targets for the CNAME"
  type        = list(string)
  default     = ["integrablesystems.github.io"]
}

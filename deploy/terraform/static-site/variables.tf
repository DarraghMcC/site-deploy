variable "www_domain_name" {
  type = string
}

variable "root_domain_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "cors_allowed_headers" {
  description = "List of headers allowed in CORS"
  type        = list(string)
  default     = []
}

variable "cors_allowed_methods" {
  description = "List of methods allowed in CORS"
  type        = list(string)
  default     = ["GET"]
}

variable "cors_allowed_origins" {
  description = "List of origins allowed to make CORS requests"
  type        = list(string)
  default     = ["https://s3.amazonaws.com"]
}

variable "cors_expose_headers" {
  description = "List of headers to expose in CORS response"
  type        = list(string)
  default     = []
}

variable "cors_max_age_seconds" {
  description = "Specifies time in seconds that browser can cache the response for a preflight request"
  type        = string
  default     = 3000
}

variable "routing_rules" {
  description = "A json array containing routing rules describing redirect behavior and when redirects are applied"
  type        = string

  default = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "/"
    },
    "Redirect": {
        "ReplaceKeyWith": "index.html"
    }
}]
EOF

}
variable "gce_project" {
  type = "string"
  description = "GCE Project ID"
}

variable "gce_region" {
  type = "string"
}

variable "disk_size" {
  type = "string"
  default = "10"
}

variable "disk_type" {
  type = "string"
  default = "SSD"
}

variable "db_tier" {
  type = "string"
}

variable "db_user" {
  type = "string"
}

variable "db_pass" {
  type = "string"
  description = "DB Password"
}

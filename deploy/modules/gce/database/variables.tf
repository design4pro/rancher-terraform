variable "name" {
  type = "string"
  description = "Cluster name"
}

variable "region" {
  type = "string"
}

variable "disk_size" {
  type = "string"
  description = "Disk size"
  default = "10"
}

variable "disk_type" {
  type = "string"
  description = "Disk type"
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

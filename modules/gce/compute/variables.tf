/*
MIT License

Copyright (c) 2018 Rafał Wolak <r.wolak@design4.pro>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

variable "cluster_name" {}
variable "region" {}
variable "machine_type" {}
variable "disk_type" {}
variable "disk_size" {}
variable "zone_list" {}
variable "instance_count" {
  default = "1"
}
variable "service_account_scopes" {
  type = "list"
}
variable "instance_metadata" {
  type = "map"
  default = {}
}
variable "instance_tags"  {
  type = "list"
  default = []
}
variable "database_endpoint" {
  default = ""
}
variable "database_user" {
  default = ""
}
variable "database_password" {
  default = ""
}
variable "docker_version" {
  default = "docker-1.12.6"
}
variable "rancher_version" {
  default = "stable"
}
variable "gce_instance_connection_name" {}

variable "ssh_pub_key" {}

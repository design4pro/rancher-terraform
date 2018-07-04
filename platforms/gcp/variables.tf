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

variable "rancher_version" {
  type    = "string"
  default = "stable"
}

variable "rancher_gcp_ext_google_managedzone_name" {
  # not to be confused with rancher_base_domain (the DNS compliant domain name)
  type        = "string"
  description = "GCP resource name of Cloud DNS ManagedZone - created outside of Rancher"
}

variable "rancher_gcp_project" {
  type = "string"
}

variable "rancher_gcp_region" {
  type        = "string"
  description = "The GCP region to use. Some regions only have 2 zones."
}

variable "rancher_gcp_compute_gce_type" {
  type        = "string"
  default     = "n1-standard-2"
  description = "Instance size for the master node(s). Example: `n1-standard-2`."
}

variable "rancher_gcp_compute_count" {
  type    = "string"
  default = "1"

  description = <<EOF
The number of master nodes to be created.
This applies only to cloud platforms.
EOF
}

variable "rancher_gcp_compute_disk_type" {
  type        = "string"
  default     = "pd-standard"
  description = "The type of disk (pd-standard or pd-ssd) for the master nodes."
}

variable "rancher_gcp_compute_disk_size" {
  type        = "string"
  default     = "30"
  description = "The size of the disk in gigabytes for the root block device of master nodes."
}

variable "rancher_gcp_compute_source_image" {
  type        = "string"
  default     = "cos-cloud/cos-stable"
  description = "The disk source image https://cloud.google.com/compute/docs/images"
}

variable "rancher_gcp_ssh_pub_key" {
  type = "string"
}

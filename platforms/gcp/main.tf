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

provider "google" {
  project = "${var.rancher_gcp_project}"
  region  = "${var.rancher_gcp_region}"
  version = "1.2.0"
}

data "google_compute_zones" "available" {}

module "gcp_compute" {
  source = "../../modules/gcp/compute"

  cluster_name           = "${var.rancher_cluster_name}"
  region                 = "${var.rancher_gcp_region}"
  machine_type           = "${var.rancher_gcp_compute_gce_type}"
  zone_list              = "${data.google_compute_zones.available.names}"
  instance_count         = "${var.rancher_gcp_compute_count}"
  disk_size              = "${var.rancher_gcp_compute_disk_size}"
  disk_type              = "${var.rancher_gcp_compute_disk_type}"
  source_image           = "${var.rancher_gcp_compute_source_image}"
  service_account_scopes = []
  rancher_version        = "${var.rancher_version}"
  rancher_base_domain    = "${var.rancher_base_domain}"
  ssh_pub_key            = "${var.rancher_gcp_ssh_pub_key}"
}

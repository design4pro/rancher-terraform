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
  region  = "${var.rancher_gcp_region}"
  version = "1.2.0"
}

module "gcp_database" {
  source = "../../modules/gcp/database"

  cluster_name = "${var.rancher_cluster_name}"
  region       = "${var.rancher_gcp_region}"
  db_tier      = "${var.rancher_gcp_database_gce_type}"
  disk_size    = "${var.rancher_gcp_database_disk_size}"
  disk_type    = "${var.rancher_gcp_database_disk_type}"
  db_user      = "${var.rancher_gcp_database_user}"
  db_pass      = "${var.rancher_gcp_database_password}"
}

data "google_compute_zones" "available" {}

module "gcp_compute" {
  source = "../../modules/gcp/compute"

  cluster_name                 = "${var.rancher_cluster_name}"
  region                       = "${var.rancher_gcp_region}"
  machine_type                 = "${var.rancher_gcp_compute_gce_type}"
  zone_list                    = "${data.google_compute_zones.available.names}"
  instance_count               = "${var.rancher_compute_count}"
  disk_size                    = "${var.rancher_gcp_compute_disk_size}"
  disk_type                    = "${var.rancher_gcp_compute_disk_type}"
  service_account_scopes       = []
  database_user                = "${var.rancher_gcp_database_user}"
  database_password            = "${var.rancher_gcp_database_password}"
  gce_instance_connection_name = "${var.rancher_gcp_project}:${var.rancher_gcp_region}:${module.gcp_database.database_name}"
  rancher_version              = "${var.rancher_version}"
  ssh_pub_key                  = "${var.rancher_gcp_ssh_pub_key}"
}

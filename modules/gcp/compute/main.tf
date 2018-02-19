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

resource "google_compute_image" "rancheros" {
  name = "rancheros"
  raw_disk {
    source = "https://storage.googleapis.com/releases.rancher.com/os/v1.0.3/rancheros-v1.0.3.tar.gz"
    sha1 = "e151a5fab00a7ee83c9f9589a42a3fbb833043c1"
  }
}

resource "google_compute_instance_template" "rancher-servers" {
  name           = "${var.cluster_name}-rancher-servers"
  region         = "${var.region}"
  machine_type   = "${var.machine_type}"
  can_ip_forward = false

  tags = ["${var.instance_tags}", "rancher-servers", "created-by-terraform"]

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = "${google_compute_image.rancheros.self_link}"
    auto_delete  = true
    boot         = true
    disk_type    = "${var.disk_type}"
    disk_size_gb = "${var.disk_size}"
  }

  network_interface {
    network = "default"
    access_config {}
  }

  service_account {
    scopes = [ "compute-ro", "storage-ro", "cloud-platform"]
  }

  metadata = "${var.instance_metadata}"

  metadata_startup_script = "${data.template_file.userdata.rendered}"
}

resource "google_compute_instance_group_manager" "rancher-servers" {
  count = 1
  name  = "${var.cluster_name}-rancher-servers-${count.index}"
  description = "Rancher Servers Instance Group Manager"

  base_instance_name = "${var.cluster_name}-rancher-server"
  instance_template  = "${google_compute_instance_template.rancher-servers.self_link}"
  update_strategy    = "NONE"
  zone               = "${element(var.zone_list, count.index)}"

  target_pools = ["${google_compute_target_pool.rancher-servers.self_link}"]
  target_size  = "${var.instance_count}"

  named_port {
    name = "rancher-api"
    port = 8080
  }
}

resource "google_compute_http_health_check" "rancher-servers" {
  name         = "${var.cluster_name}-rancher-servers-health-check"
  description  = "Health check for Rancher instances"
  request_path = "/v1/scripts/api.crt"
  port         = "8080"

  timeout_sec         = 2
  check_interval_sec  = 30
  unhealthy_threshold = 2
}

resource "google_compute_target_pool" "rancher-servers" {
  name        = "${var.cluster_name}-rancher-servers-target"
  description = "Target pool for Rancher"
  depends_on  = ["google_compute_http_health_check.rancher-servers"]

  health_checks = [
    "${google_compute_http_health_check.rancher-servers.name}",
  ]
  // Options are "NONE" (no affinity). "CLIENT_IP" (hash of the source/dest addresses / ports), and "CLIENT_IP_PROTO" also includes the protocol (default "NONE").
  session_affinity = "NONE"
}

data "template_file" "userdata" {
  template = "${file("${path.module}/files/userdata.template")}"

  vars {
    database_user                = "${var.database_user}"
    database_password            = "${var.database_password}"
    rancher_version              = "${var.rancher_version}"
    docker_version               = "${var.docker_version}"
    gce_instance_connection_name = "${var.gce_instance_connection_name}"
    ssh_pub_key                  = "${var.ssh_pub_key}"
  }
}

resource "google_compute_forwarding_rule" "rancher-servers" {
  name                  = "${var.cluster_name}-rancher-servers-forwarder"
  description           = "Externally facing forwarder for Rancher"
  target                = "${google_compute_target_pool.rancher-servers.self_link}"
  ip_protocol           = "TCP"
  port_range            = "80-8080"
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_firewall" "default" {
  name    = "${var.cluster_name}-rancher-servers-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["rancher-servers"]
}

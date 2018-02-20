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

resource "random_id" "database" {
   byte_length = 4
}

// Instance
resource "google_sql_database_instance" "master" {
  name             = "${var.cluster_name}-rancher-master-${random_id.database.hex}"
  region           = "${var.region}"
  database_version = "${var.db_version}"

  settings {
    tier            = "${var.db_tier}"
    disk_size       = "${var.disk_size}"
    disk_type       = "${var.disk_type}"
    disk_autoresize = "true"

    ip_configuration {
      ipv4_enabled = true
    }

    backup_configuration {
      binary_log_enabled = "true"
      enabled            = "true"
      start_time         = "${var.db_backup_start_time}"
    }

    location_preference {
      zone = "${lookup(var.regions["${var.region}"], "zone1")}"
    }
  }
}

resource "google_sql_database_instance" "failover" {
  count                 = 1
  name                  = "${var.cluster_name}-rancher-failover-${count.index}-${random_id.database.hex}"
  region                = "${var.region}"
  database_version      = "${var.db_version}"
  master_instance_name  = "${google_sql_database_instance.master.name}"

  replica_configuration {
    failover_target = "true"
  }

  settings {
    tier            = "${var.db_tier}"
    disk_size       = "${var.disk_size}"
    disk_type       = "${var.disk_type}"
    disk_autoresize = "true"

    ip_configuration {
      ipv4_enabled = true
    }

    location_preference {
      zone = "${lookup(var.regions["${var.region}"], "zone2")}"
    }
  }
}

// Database
resource "google_sql_database" "master" {
  name     = "cattle"
  instance = "${google_sql_database_instance.master.name}"

  # Tells Terraform that this instance must be created only after the
  # master instance has been created.
  depends_on = ["google_sql_database_instance.master"]
}

// User
resource "google_sql_user" "default" {
  name     = "${var.db_user}"
  instance = "${google_sql_database_instance.master.name}"
  host     = "%"
  password = "${var.db_pass}"

  # Tells Terraform that this instance must be created only after the
  # master instance has been created.
  depends_on = ["google_sql_database_instance.master"]
}

// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("~/.gce/credentials")}"
  project     = "${var.gce_project}"
  region      = "${var.gce_region}"
}

resource "random_id" "database" {
  byte_length = 4
}

module "gce_database" {
  source = "../../modules/gce/database"

  name = "rancher-${random_id.database.hex}"
  region = "${var.gce_region}"
  db_tier = "${var.db_tier}"
  disk_size = "${var.disk_size}"
  disk_type = "${var.disk_type}"
  db_user = "${var.db_user}"
  db_pass = "${var.db_pass}"
}

output "name" {
  value = "${module.gce_database.name}"
}

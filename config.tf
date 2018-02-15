terraform {
  required_version = ">= 0.10.7"
  backend "gcs" {
    bucket  = "rancher-terraform"
    prefix  = "terraform/state"
  }
}

provider "archive" {
  version = "1.0.0"
}

provider "external" {
  version = "1.0.0"
}

provider "ignition" {
  version = "1.0.0"
}

provider "local" {
  version = "1.0.0"
}

provider "null" {
  version = "1.0.0"
}

provider "random" {
  version = "1.0.0"
}

provider "template" {
  version = "1.0.0"
}

provider "tls" {
  version = "1.0.1"
}

variable "rancher_base_domain" {
  type = "string"

  description = <<EOF
The base DNS domain of the cluster. It must NOT contain a trailing period. Some
DNS providers will automatically add this if necessary.
Example: `rancher.dev`.
Note: This field MUST be set manually prior to creating the cluster.
This applies only to cloud platforms.
EOF
}

variable "rancher_cluster_name" {
  type = "string"

  description = <<EOF
The name of the cluster.
If used in a cloud-environment, this will be prepended to `rancher_base_domain` resulting in the URL to the Rancher.
Note: This field MUST be set manually prior to creating the cluster.
EOF
}

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

# Region & Zone Map
variable "rancher_gcp_regions" {
  type = "map"
  default {
    asia-east1 {
      zone1 = "asia-east1-a"
      zone2 = "asia-east1-b"
      zone3 = "asia-east1-c"
    }
    asia-northeast1 {
      zone1 = "asia-northeast1-a"
      zone2 = "asia-northeast1-b"
      zone3 = "asia-northeast1-c"
    }
    asia-south1 {
      zone1 = "asia-south1-a"
      zone2 = "asia-south1-b"
      zone3 = "asia-south1-c"
    }
    asia-southeast1 {
      zone1 = "asia-southeast1-a"
      zone2 = "asia-southeast1-b"
    }
    australia-southeast1 {
      zone1 = "australia-southeast1-a"
      zone2 = "australia-southeast1-b"
      zone3 = "australia-southeast1-c"
    }
    europe-west1 {
      zone1 = "europe-west1-b"
      zone2 = "europe-west1-c"
      zone3 = "europe-west1-d"
    }
    europe-west2 {
      zone1 = "europe-west2-a"
      zone2 = "europe-west2-b"
      zone3 = "europe-west2-c"
    }
    europe-west3 {
      zone1 = "europe-west3-a"
      zone2 = "europe-west3-b"
      zone3 = "europe-west3-c"
    }
    southamerica-east1 {
      zone1 = "southamerica-east1-a"
      zone2 = "southamerica-east1-b"
      zone3 = "southamerica-east1-c"
    }
    us-central1 {
      zone1 = "us-central1-a"
      zone2 = "us-central1-b"
      zone3 = "us-central1-c"
      zone4 = "us-central1-f"
    }
    us-east1 {
      zone1 = "us-east1-b"
      zone2 = "us-east1-c"
      zone3 = "us-east1-d"
    }
    us-east4 {
      zone1 = "us-east4-a"
      zone2 = "us-east4-b"
      zone3 = "us-east4-c"
    }
    us-west1 {
      zone1 = "us-west1-a"
      zone2 = "us-west1-b"
      zone3 = "us-west1-c"
    }
  }
}

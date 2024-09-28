// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

terraform {
  required_providers {
    ipam = {
      version = "0.3"
      source = "<cloud_run_host>/ipam-autopilot/ipam"
    }
  }
}

provider "ipam" {
  url = "https://<cloud_run_host>"
}

resource "ipam_routing_domain" "test" {
  name = "Test Network Domain"
  vpcs = [google_compute_network.vpc_network.self_link]
}

resource "google_compute_network" "vpc_network" {
  name = "test-network"
  auto_create_subnetworks = false
  project = var.project_id
}

variable "project_id" {
  
}
resource "ipam_ip_range" "main" {
  range_size = 8
  name = "main range"
  domain = ipam_routing_domain.test.id
  cidr = "10.0.0.0/8"
}

resource "ipam_ip_range" "pod_ranges" {
  range_size = 22
  name = "gke pod range"
  domain = ipam_routing_domain.test.id
  parent = ipam_ip_range.main.cidr
}

resource "google_compute_subnetwork" "pod-subnet" {
  # Drata: Configure [google_compute_subnetwork.log_config] to ensure that security-relevant events are logged to detect malicious activity
  name          = "gke-pods"
  ip_cidr_range = ipam_ip_range.pod_ranges.cidr
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
  project = var.project_id
}

resource "ipam_ip_range" "services_ranges" {
  range_size = 22
  name = "gke services range"
  domain = ipam_routing_domain.test.id
  parent = ipam_ip_range.main.cidr
}

resource "google_compute_subnetwork" "services-subnet" {
  # Drata: Configure [google_compute_subnetwork.log_config] to ensure that security-relevant events are logged to detect malicious activity
  name          = "gke-services"
  ip_cidr_range = ipam_ip_range.services_ranges.cidr
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
  project = var.project_id
}

resource "ipam_ip_range" "third_range" {
  range_size = 20
  name = "third range"
  domain = ipam_routing_domain.test.id
}
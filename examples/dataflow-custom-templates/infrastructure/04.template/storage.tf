# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

// A storage bucket reserved for templates
resource "google_storage_bucket" "dataflow_templates" {
  # Drata: Set [google_storage_bucket.versioning.enabled] to [true] to enable infrastructure versioning and prevent accidental deletions and overrides
  # Drata: Configure [google_storage_bucket.labels] to ensure that organization-wide label conventions are followed.
  # Drata: Specify [google_storage_bucket.retention_policy.retention_period] to [2678400] to ensure sensitive data is only available when necessary
  location                    = "us"
  name                        = "dataflow-templates-${random_string.dataflow_templates_postfix.result}"
  uniform_bucket_level_access = true
  provisioner "local-exec" {
    command = "gsutil pap set enforced gs://${google_storage_bucket.dataflow_templates.name}"
  }
}

// Generate a random string postfix so that the dataflow template name is unique
resource "random_string" "dataflow_templates_postfix" {
  special = false
  upper   = false
  length  = 8
}
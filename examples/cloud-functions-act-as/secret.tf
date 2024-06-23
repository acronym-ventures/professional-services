/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
resource "google_secret_manager_secret" "access-token-secret" {
  # Drata: Set [configId] to ensure that organization-wide label conventions are followed.
  # Drata: Configure [google_secret_manager_secret.rotation.rotation_period] to minimize the risk of secret exposure by ensuring that sensitive values are periodically rotated
  secret_id = "access-token-secret"
  replication {
    user_managed {
      replicas {
        location = var.location
      }
    }
  }
}
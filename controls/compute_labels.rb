# Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

gcp_project_id = attribute('project_id', description:'GCP project id')

portefaix_version = input('portefaix_version')
portefaix_section = 'compute.labels'

title "Compute labels standards"

# Compute.Labels.1
# =======================================================

portefaix_req = "#{portefaix_section}.1"

control "portefaix-gcp-#{portefaix_version}-#{portefaix_req}" do
  title 'Ensure compute instances have all mandatory labels'
  desc ""
  impact 1.0

  tag project: "#{gcp_project_id}"
  tag standard: "portefaix"
  tag portefaix_version: "#{portefaix_version}"
  tag portefaix_section: "#{portefaix_section}"
  tag portefaix_req: "#{portefaix_req}"

  ref "Portefaix GCP #{portefaix_version}, #{portefaix_section}"

  google_compute_zones(project: gcp_project_id).where(zone_name: /^eu/).zone_names.each do |zone_name|
    google_compute_instances(project: gcp_project_id, zone: zone_name).instance_names.each do |instance_name|
      describe google_compute_instance(project: gcp_project_id, zone: zone_name, name: instance_name) do
        it { should exist }
        # its('name') { should match '#{CUSTOMER}' }
        its('labels.keys') { should include 'env' }
        its('labels.keys') { should include 'service' }
        its('labels.keys') { should include 'made-by' }
      end
    end
  end

end

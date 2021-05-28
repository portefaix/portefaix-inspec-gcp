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
# location = attribute("location", description:'GCP location')
# network_name= attribute("network_name")

portefaix_version = input('portefaix_version')
portefaix_section = 'networking'

title "Networking standards"

# Networking.1
# =======================================================

portefaix_req = "#{portefaix_section}.1"

control "portefaix-gcp-#{portefaix_version}-#{portefaix_req}" do
  title 'Ensure default network is deleted'
  desc ""
  impact 1.0

  tag project: "#{gcp_project_id}"
  tag standard: "portefaix"
  tag portefaix_version: "#{portefaix_version}"
  tag portefaix_section: "#{portefaix_section}"
  tag portefaix_req: "#{portefaix_req}"
  
  ref "Portefaix GCP #{portefaix_version}, #{portefaix_section}"

  google_compute_firewalls(project: gcp_project_id).where { firewall_name !~ /^gke/ }.firewall_names.each do |firewall_name|
    describe "[#{portefaix_version}][#{portefaix_req}][#{gcp_project_id}] #{firewall_name}" do
      subject { google_compute_firewall(project: gcp_project_id, name: firewall_name) }
      its('description') { should match(/#{fw_change_control_id_regex}/) }
    end
  end

end
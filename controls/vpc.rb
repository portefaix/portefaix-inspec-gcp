# Copyright (C) Nicolas Lamirault <nicolas.lamirault@gmail.com>
#
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
#
# SPDX-License-Identifier: Apache-2.0

gcp_project_id = attribute('project_id', description:'GCP project id')
# location = attribute("location", description:'GCP location')
# network_name= attribute("network_name")

portefaix_version = input('portefaix_version')
portefaix_section = 'vpc'

title "VPC standards"

# VPC.1
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

  describe google_compute_network(project: gcp_project_id, name: 'default') do
    it { should_not exist }
  end

end

# Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>
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

gcp_project_id = attribute('project_id', description:'GCP project id')
cluster_name = attribute('kubernetes_cluster_name', description:'The cluster name')
location = attribute('kubernetes_location', description:'The cluster location')
node_pool_count = attribute('kubernetes_node_pool_count', description:'Number of node pool into the Kubernetes cluster')

portefaix_version = input('portefaix_version')
portefaix_section = 'kubernetes.labels'

title "Kubernetes labels standards"

# Kubernetes.Labels.1
# =======================================================

portefaix_req = "#{portefaix_section}.1"

control "portefaix-gcp-#{portefaix_version}-#{portefaix_req}" do
  title 'Ensure Kubernetes cluster have all mandatory labels'
  desc ""
  impact 1.0

  tag project: "#{gcp_project_id}"
  tag standard: "portefaix"
  tag portefaix_version: "#{portefaix_version}"
  tag portefaix_section: "#{portefaix_section}"
  tag portefaix_req: "#{portefaix_req}"

  ref "Portefaix GCP #{portefaix_version}, #{portefaix_section}"

  google_container_clusters(project: gcp_project_id, location: location).where(cluster_name: cluster_name).cluster_names.each do |cluster_name|
    describe google_container_cluster(project: gcp_project_id, location: location, name: cluster_name) do
      it { should exist }
      its('status') { should eq 'RUNNING' }
      its('resource_labels.keys') { should include 'env' }
      its('resource_labels.keys') { should include 'service' }
      its('resource_labels.keys') { should include 'made-by' }
    end
  end

end

# Kubernetes.Labels.2
# =======================================================

portefaix_req = "#{portefaix_section}.2"

control "portefaix-gcp-#{portefaix_version}-#{portefaix_req}" do
  title 'Ensure Kubernetes cluster node pools have all mandatory labels'
  desc ""
  impact 1.0

  tag project: "#{gcp_project_id}"
  tag standard: "portefaix"
  tag portefaix_version: "#{portefaix_version}"
  tag portefaix_section: "#{portefaix_section}"
  tag portefaix_req: "#{portefaix_req}"

  ref "Portefaix GCP #{portefaix_version}, #{portefaix_section}"

  google_container_node_pools(project: gcp_project_id, location: location, cluster_name: cluster_name).where(node_pool_name: /-pool$/).node_pool_names.each do |node_pool_name|
    describe google_container_node_pool(project: gcp_project_id, location: location, cluster_name: cluster_name, nodepool_name: node_pool_name) do
      it { should exist }
      its('status') { should eq 'RUNNING' }
      its('labels.keys') { should include 'env' }
      its('labels.keys') { should include 'service' }
      its('labels.keys') { should include 'made-by' }
    end
  end
end

############################################################################

portefaix_section_node_pool = 'kubernetes.node_pool'

title "Kubernetes node pool standards"

# Kubernetes.NodePool.1
# =======================================================

portefaix_req = "#{portefaix_section_node_pool}.1"

control "portefaix-gcp-#{portefaix_version}-#{portefaix_req}" do
  title 'Ensure Kubernetes cluster have all mandatory labels'
  desc ""
  impact 1.0

  tag project: "#{gcp_project_id}"
  tag standard: "portefaix"
  tag portefaix_version: "#{portefaix_version}"
  tag portefaix_section: "#{portefaix_section_node_pool}"
  tag portefaix_req: "#{portefaix_req}"

  ref "Portefaix GCP #{portefaix_version}, #{portefaix_section_node_pool}"

  google_container_clusters(project: gcp_project_id, location: location,).where(cluster_name: cluster_name).cluster_names.each do |cluster_name|
    describe google_container_cluster(project: gcp_project_id, location: location, name: cluster_name) do
      its('status') { should eq 'RUNNING' }
      # its('node_config.disk_size_gb'){should eq 100}
      its('node_config.image_type') { should eq "COS_CONTAINERD" }
      # its('node_config.machine_type'){should eq "n1-standard-1"}
      its('node_pools.count') { should eq node_pool_count }
      # its('node_config.oauth_scopes') { should eq ["https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring"] }
      # its('node_config.service_account') { should eq service_account }
    end
  end

end

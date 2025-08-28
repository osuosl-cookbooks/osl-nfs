#
# Cookbook:: osl-nfs
# Recipe:: homes
#
# Copyright:: 2013-2025, Oregon State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node.default['firewall']['nfs']['range']['4'] = %w(10.162.136.0/24)
include_recipe 'osl-nfs::default'

directory '/data/homes/' do
  recursive true
end

nfs_export '/data/homes/' do
  network '10.162.136.0/24'
  writeable true
  options ['mountpoint,no_root_squash']
end

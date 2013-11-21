#
# Cookbook Name:: osl-nfs
# Recipe:: default
#
# Copyright (C) 2013 Oregon State University
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

# Firewall rules for nfs server
simple_iptables_rule "nfs-mountd" do
  rule ["--proto tcp --dport #{node['nfs']['port']['mountd']}",
    "--proto udp --dport #{node['nfs']['port']['mountd']}",
    "--proto tcp --dport #{node['nfs']['port']['statd']}",
    "--proto udp --dport #{node['nfs']['port']['statd']}",
    "--proto tcp --dport #{node['nfs']['port']['statd_out']}",
    "--proto udp --dport #{node['nfs']['port']['statd_out']}",
    "--proto tcp --dport #{node['nfs']['port']['lockd']}",
    "--proto udp --dport #{node['nfs']['port']['lockd']}",
    "--proto tcp --dport nfs",
    "--proto udp --dport nfs",
    "--proto tcp --dport sunrpc",
    "--proto udp --dport sunrpc"]
  jump "ACCEPT"
end

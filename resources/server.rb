resource_name :osl_nfs_server
provides :osl_nfs_server
default_action :create
unified_mode true

property :allowed_ipv4, Array,
         default: [],
         callbacks: {
           'must be a list of IPv4 addresses or CIDRs' => ->(v) { OslNfs::Cookbook::Helpers.osl_nfs_ip_list?(v, :ipv4) },
         },
         description: 'IPv4 sources allowed to reach the NFS ports; with both lists empty, OSL-managed ranges only'

property :allowed_ipv6, Array,
         default: [],
         callbacks: {
           'must be a list of IPv6 addresses or CIDRs' => ->(v) { OslNfs::Cookbook::Helpers.osl_nfs_ip_list?(v, :ipv6) },
         },
         description: 'IPv6 sources allowed to reach the NFS ports; empty while allowed_ipv4 is set closes IPv6'

action :create do
  # Two servers would leave the osl_only rules next to the limited ones
  if node.run_state['osl_nfs_server']
    raise "osl_nfs_server[#{new_resource.name}]: osl_nfs_server[#{node.run_state['osl_nfs_server']}] " \
          'already manages this node; declare one osl_nfs_server per node'
  end
  node.run_state['osl_nfs_server'] = new_resource.name

  nfs_server 'default'

  if new_resource.allowed_ipv4.empty? && new_resource.allowed_ipv6.empty?
    # Lists left unset: an empty list would render no rule at all, not -j osl_only
    osl_firewall_nfs 'osl-nfs'
  else
    osl_firewall_nfs 'osl-nfs' do
      osl_only false
      allowed_ipv4 new_resource.allowed_ipv4
      allowed_ipv6 new_resource.allowed_ipv6
    end
  end
end

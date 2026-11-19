require 'ipaddr'

module OslNfs
  module Cookbook
    module Helpers
      # True when every entry is an address or CIDR of the given family (:ipv4 or :ipv6)
      def osl_nfs_ip_list?(list, family)
        list.all? do |ip|
          addr = IPAddr.new(ip)
          family == :ipv4 ? addr.ipv4? : addr.ipv6?
        rescue ArgumentError, TypeError # IPAddr::Error is an ArgumentError
          false
        end
      end
      module_function :osl_nfs_ip_list?
    end
  end
end
Chef::DSL::Recipe.include ::OslNfs::Cookbook::Helpers
Chef::Resource.include ::OslNfs::Cookbook::Helpers

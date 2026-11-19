require_relative '../../spec_helper'

NFS_PORTS = %w(111 2049 32765 32766 32767 32768 32769).freeze

describe 'osl_nfs_server' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      platform p[:platform], p[:version]
      step_into :osl_nfs_server, :osl_firewall_nfs, :osl_firewall_rule

      context 'default' do
        cached(:subject) { chef_run }
        recipe do
          osl_nfs_server 'default'
        end

        it { is_expected.to create_nfs_server('default') }
        it { is_expected.to accept_osl_firewall_nfs('osl-nfs').with(osl_only: true) }

        %i(ipv4 ipv6).each do |ipver|
          NFS_PORTS.each do |port|
            %i(tcp udp).each do |proto|
              it do
                is_expected.to create_iptables_rule("#{ipver} nfs :#{port}/#{proto}").with(
                  chain: :nfs,
                  extra_options: "--dport #{port}",
                  jump: 'osl_only',
                  ip_version: ipver
                )
              end
            end
          end
        end
      end

      context 'allowed_ipv4 only' do
        cached(:subject) { chef_run }
        recipe do
          osl_nfs_server 'default' do
            allowed_ipv4 %w(10.1.0.0/23 192.0.2.10)
          end
        end

        it do
          is_expected.to accept_osl_firewall_nfs('osl-nfs').with(
            osl_only: false,
            allowed_ipv4: %w(10.1.0.0/23 192.0.2.10),
            allowed_ipv6: []
          )
        end

        %w(10.1.0.0/23 192.0.2.10).each do |ip|
          NFS_PORTS.each do |port|
            %i(tcp udp).each do |proto|
              it do
                is_expected.to create_iptables_rule("ipv4 nfs #{ip}:#{port}/#{proto}").with(
                  chain: :nfs,
                  source: ip,
                  extra_options: "--dport #{port}",
                  jump: 'ACCEPT',
                  ip_version: :ipv4
                )
              end
            end
          end
        end

        it { is_expected.to_not create_iptables_rule('ipv4 nfs :2049/tcp') }
        it { is_expected.to_not create_iptables_rule('ipv6 nfs :2049/tcp') }
        it { is_expected.to create_iptables_rule('ipv6 nfs accept') }
      end

      context 'allowed_ipv4 and allowed_ipv6' do
        cached(:subject) { chef_run }
        recipe do
          osl_nfs_server 'default' do
            allowed_ipv4 %w(10.1.0.0/23)
            allowed_ipv6 %w(2001:db8::/64)
          end
        end

        it { is_expected.to create_iptables_rule('ipv4 nfs 10.1.0.0/23:2049/tcp').with(jump: 'ACCEPT') }
        it { is_expected.to create_iptables_rule('ipv6 nfs 2001:db8::/64:2049/tcp').with(jump: 'ACCEPT') }
        it { is_expected.to_not create_iptables_rule('ipv6 nfs :2049/tcp') }
      end

      context 'a second osl_nfs_server' do
        recipe do
          osl_nfs_server 'default'
          osl_nfs_server 'second'
        end

        it { expect { chef_run }.to raise_error(RuntimeError, /already manages this node/) }
      end

      [
        ['allowed_ipv4', %w(2001:db8::/64)],
        ['allowed_ipv4', ['nfs.example.org']],
        ['allowed_ipv4', [nil]],
        ['allowed_ipv6', %w(10.1.0.0/23)],
      ].each do |prop, value|
        context "#{prop} #{value.inspect}" do
          recipe do
            osl_nfs_server 'default' do
              send(prop, value)
            end
          end

          it { expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed) }
        end
      end
    end
  end
end

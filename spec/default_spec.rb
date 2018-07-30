require_relative 'spec_helper'

describe 'osl-nfs::default' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p).converge(described_recipe)
      end
      it do
        expect { chef_run }.to_not raise_error
      end
      %w(nfs::server firewall::nfs).each do |r|
        it do
          expect(chef_run).to include_recipe(r)
        end
      end
      case p
      when CENTOS_7
        it do
          expect(chef_run).to load_kernel_module('lockd')
            .with(
              onboot: true,
              options: %w(nlm_tcpport=32768 nlm_udpport=32768)
            )
        end
        %w(tcp udp).each do |proto|
          it do
            expect(chef_run).to apply_sysctl_param("fs.nfs.nlm_#{proto}port").with(value: '32768')
          end
          it do
            expect(chef_run.sysctl_param("fs.nfs.nlm_#{proto}port")).to notify('service[nfs-server]')
          end
        end
      when CENTOS_6
        it do
          expect(chef_run).to_not load_kernel_module('lockd')
        end
        %w(tcp udp).each do |proto|
          it do
            expect(chef_run).to_not apply_sysctl_param("fs.nfs.nlm_#{proto}port").with(value: '32768')
          end
        end
      end
    end
  end
end

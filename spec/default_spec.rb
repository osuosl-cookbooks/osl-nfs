require_relative 'spec_helper'

describe 'osl-nfs::default' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p) do |node|
          node.automatic['kernel']['modules'] = %w(nfs) if p == CENTOS_7
        end.converge(described_recipe)
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
      when CENTOS_6
        it do
          expect(chef_run).to_not load_kernel_module('lockd')
        end
      end
    end
  end
end

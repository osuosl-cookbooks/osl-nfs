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

      it { expect(chef_run).to create_nfs_server('default') }

      it { expect(chef_run).to accept_osl_firewall_nfs('osl-nfs') }
    end
  end
end

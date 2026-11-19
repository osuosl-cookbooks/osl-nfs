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

      it { expect(chef_run).to create_osl_nfs_server('default').with(allowed_ipv4: [], allowed_ipv6: []) }
    end
  end
end

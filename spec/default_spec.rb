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
      %w(
        nfs::server
        firewall::nfs
      ).each do |r|
        it do
          expect(chef_run).to include_recipe(r)
        end
      end
    end
  end
end

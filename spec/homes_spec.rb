require_relative 'spec_helper'

describe 'osl-nfs::homes' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(CENTOS_6_OPTS).converge(described_recipe)
  end
  it do
    expect(chef_run).to include_recipe('osl-nfs::default')
  end
  it do
    expect(chef_run).to create_directory('/data/homes/')
  end
  it do
    expect(chef_run).to create_nfs_export('/data/homes/')
  end
end

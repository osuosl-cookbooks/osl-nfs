require 'serverspec'

set :backend, :exec

describe service('nfs') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/exports') do
  it { should be_file }
  its(:content) do
    should match(%r{/data/homes/ 10.1.0.0/23\(rw,sync,mountpoint,no_root_squash\)})
  end
end

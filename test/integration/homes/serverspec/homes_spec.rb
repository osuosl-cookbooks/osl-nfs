require 'serverspec'

set :backend, :exec

describe service('nfs') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/exports') do
  it { should be_file }
  its(:content) do
    should eq("/data/homes/ " + (1..26).map{ |o| '10.1.1.' + o.to_s + '/32(rw,sync,mountpoint,no_root_squash)'}.join(' ') + "\n")
  end
end

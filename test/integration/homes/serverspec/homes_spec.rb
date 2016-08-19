require 'serverspec'

set :backend, :exec

describe service('nfs') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/exports') do
  it { should be_file }
  its(:content) do
    should eq('/data/homes/ ' + (1..254).map do |o|
      '10.162.136.' + o.to_s + '/24(rw,sync,mountpoint,no_root_squash)'
    end.join(' ') + "\n")
  end
end

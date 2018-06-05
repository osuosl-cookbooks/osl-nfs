require 'serverspec'

set :backend, :exec

shared_examples 'nfs' do
  if os[:release].to_i < 7
    describe service('nfs') do
      it { should be_enabled }
      it { should be_running }
    end
  else
    describe service('nfs') do
      # Only check enabled on CentOS 7 since this service just runs and exits
      it { should be_enabled }
    end
    describe service('nfs-mountd') do
      it { should be_enabled }
      it { should be_running }
    end
    describe service('nfs-idmapd') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end

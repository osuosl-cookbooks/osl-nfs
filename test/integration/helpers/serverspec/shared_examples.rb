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
  describe command('rpcinfo -p localhost') do
    [
      %w(111 portmapper),
      %w(32765 status),
      %w(32767 mountd),
      %w(2049 nfs),
      %w(2049 nfs_acl),
      %w(32768 nlockmgr),
    ].each do |port, service|
      its(:stdout) { should match(/tcp.*#{port}.*#{service}$/) }
      its(:stdout) { should match(/udp.*#{port}.*#{service}$/) }
    end
  end
end

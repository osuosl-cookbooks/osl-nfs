describe service(os.release.to_i >= 8 ? 'nfs-server' : 'nfs') do
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

describe command('rpcinfo -p localhost') do
  [
    %w(2049 nfs),
    %w(2049 nfs_acl),
  ].each do |port, service|
    its('stdout') { should match(/tcp.*#{port}.*#{service}$/) }
    if os.release.to_i == 7
      its('stdout') { should match(/udp.*#{port}.*#{service}$/) }
    end
  end

  [
    %w(111 portmapper),
    %w(32765 status),
    %w(32767 mountd),
    %w(32768 nlockmgr),
  ].each do |port, service|
    its('stdout') { should match(/tcp.*#{port}.*#{service}$/) }
    its('stdout') { should match(/udp.*#{port}.*#{service}$/) }
  end
end

describe service 'nfs-server' do
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

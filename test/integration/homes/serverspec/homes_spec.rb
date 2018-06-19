require 'shared_examples'

describe 'default' do
  it_behaves_like 'nfs'
end

describe file('/etc/exports') do
  its(:content) do
    should eq("/data/homes/ 10.162.136.0/24(rw,sync,mountpoint,no_root_squash)\n")
  end
end

describe iptables do
  %w(tcp udp).each do |proto|
    %w(111 2049 32765 32766 32767 32768).each do |port|
      it do
        should have_rule("-A nfs -s 10.162.136.0/24 -p #{proto} -m #{proto} --dport #{port} -j ACCEPT")
      end
    end
  end
end

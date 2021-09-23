include_controls 'default'

control 'homes' do
  describe file('/etc/exports') do
    its('content') { should cmp %r{/data/homes/ 10.162.136.0/24\(rw,sync,mountpoint,no_root_squash\)} }
  end

  describe iptables do
    %w(tcp udp).each do |proto|
      %w(111 2049 32765 32766 32767 32768 32769).each do |port|
        it do
          should have_rule("-A nfs -p #{proto} -m #{proto} --dport #{port} -j osl_only")
        end
      end
    end
  end
end

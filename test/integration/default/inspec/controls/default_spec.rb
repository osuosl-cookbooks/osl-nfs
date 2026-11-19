docker = inspec.command('test -e /.dockerenv')

# With no allowed sources, every NFS port goes through osl_only
describe iptables do
  %w(tcp udp).each do |proto|
    %w(111 2049 32765 32766 32767 32768 32769).each do |port|
      it { should have_rule("-A nfs -p #{proto} -m #{proto} --dport #{port} -j osl_only") }
    end
  end
end unless docker

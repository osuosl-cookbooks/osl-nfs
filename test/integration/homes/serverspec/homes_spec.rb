require 'shared_examples'

describe 'default' do
  it_behaves_like 'nfs'
end

describe file('/etc/exports') do
  its(:content) do
    should eq('/data/homes/ 10.162.136.0/24(rw,sync,mountpoint,' \
      'no_root_squash)' + "\n")
  end
end

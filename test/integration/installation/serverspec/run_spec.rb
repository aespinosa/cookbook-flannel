require 'serverspec'

set :backend, :exec

describe command '/usr/sbin/flanneld -version' do
  its :exit_status do
    should eq 0
  end

  its :stderr do
    should match %r(0.5.5)
  end
end

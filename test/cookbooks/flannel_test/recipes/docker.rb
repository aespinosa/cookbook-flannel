etcd_service 'flannel' do
  action %w(create start)
end

flannel_service 'default' do
  action %w(create start)
end.extend FlannelCookbook::SubnetParser

docker_service 'default' do
  bip lazy { resources('flannel_service[default]').subnetfile_subnet }
  mtu lazy { resources('flannel_service[default]').subnetfile_mtu }
  action %w(create start)
end

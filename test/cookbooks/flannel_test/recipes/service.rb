etcd_service 'flannel' do
  action %w(create start)
end

flannel_service 'default' do
  action %w(create start)
end

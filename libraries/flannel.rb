module FlannelCookbook
  class FlannelService < Chef::Resource
    resource_name :flannel_service
    provides :flannel_service

    default_action :create

    action :create do
      
      remote_file 'flannel tarball' do
        path "#{file_cache_path}/flannel-0.5.5-linux-amd64.tar.gz"
        source 'https://github.com/coreos/flannel/releases/download/v0.5.5/flannel-0.5.5-linux-amd64.tar.gz'
        checksum '78127e165f124a8f8ddf2391f8b775b3494aec7e693928f78f2328256fe3644c'
      end

      execute 'extract flanneld' do
        command "tar xvf #{tarball_path} -C /usr/sbin flannel-0.5.5/flanneld --strip-components=1"
        action :nothing
        subscribes :run, 'remote_file[flannel tarball]'
      end

    end

    action :start do
      service_file = template "/etc/systemd/system/#{flannel_name}.service" do
        source 'systemd/flannel.service.erb'
        owner 'root'
        group 'root'
        cookbook 'flannel'

        variables config: { 'Network' => '10.0.0.0/8' }

        action :create

        notifies :run, 'execute[systemctl daemon-reload]', :immediately
      end

      execute 'systemctl daemon-reload' do
        command '/bin/systemctl daemon-reload'
        action :nothing
      end

      service flannel_name do
        provider Chef::Provider::Service::Systemd
        supports status: true
        action %w(enable start)
        only_if { ::File.exist? service_file.path }
      end
    end

    def file_cache_path
      Chef::Config[:file_cache_path]
    end

    def tarball_path
      "#{file_cache_path}/flannel-0.5.5-linux-amd64.tar.gz"
    end

    def flannel_name
      "flannel-#{name}"
    end
  end
end

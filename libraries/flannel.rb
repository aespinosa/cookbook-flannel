require_relative 'command_generators'

module FlannelCookbook
  # flannel_resource
  class Resource < Chef::Resource
    include CommandGenerators

    resource_name :flannel_service
    provides :flannel_service

    default_action :create

    # Reference: https://github.com/coreos/flannel#configuration
    property :configuration, Hash, default: { 'Network' => '10.0.0.1/8' }

    IPV4_ADDR ||= /((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.)
                   {3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])/x

    # Reference: https://github.com/coreos/flannel#key-command-line-options
    property :public_ip, [IPV4_ADDR, nil]
    property :etcd_endpoints, String
    property :etcd_prefix, String, default: '/coreos.com/network/config'
    property :etcd_keyfile, String
    property :etcd_certfile, String
    property :etcd_cafile, String
    property :iface, String
    property :subnet_file, String, default: '/run/flannel/subnet.env'
    property :ip_masq, [true, false], default: false
    property :listen, String
    property :remote, String
    property :remote_keyfile, String
    property :remote_certfile, String
    property :networks, [String, Array]
    property :log_level, [0, 1, 2], default: 0
    property :etcdctl_options, [String, nil], default: nil

    alias v log_level

    action :create do
      remote_file 'flannel tarball' do
        path tarball_path
        source 'https://github.com/coreos/flannel/releases/download/v0.5.5'\
               '/flannel-0.5.5-linux-amd64.tar.gz'
        checksum '78127e165f124a8f8ddf2391f8b775b3'\
                 '494aec7e693928f78f2328256fe3644c'
      end

      execute 'extract flanneld' do
        command "tar xvf #{tarball_path} -C #{flanneld_bin_prefix} "\
                '--wildcards "*/flanneld" --strip-components=1'
        action :nothing
        subscribes :run, 'remote_file[flannel tarball]'
      end
    end

    action :configure do
      execute 'configure flannel' do
        command etcdctl_command
        action :run
      end
    end

    action :start do
      service_file = template "/etc/systemd/system/#{flannel_name}.service" do
        source 'systemd/flannel.service.erb'
        owner 'root'
        group 'root'
        cookbook 'flannel'

        variables flanneld_command: flanneld_command

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

    def flanneld_bin_prefix
      '/usr/sbin'
    end
  end
end

module FlannelCookbook
  class FlannelService < Chef::Resource
    resource_name :flannel_service
    provides :flannel_service

    default_action :create

    IPV4_ADDR ||= /((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])/

    # Reference: https://github.com/coreos/flannel#key-command-line-options
    property :public_ip, [IPV4_ADDR, nil]
    property :etcd_endpoints, String
    property :etcd_prefix, String, default: '/coreos.com/network/config'
    property :etcd_keyfile, String
    property :etcd_cafile, String
    property :iface, String
    property :subnet_file, String, default: '/run/flannel/subnet.env'
    property :ip_masq, [true, false]
    property :listen, String
    property :remote, String
    property :remote_keyfile, String
    property :remote_certfile, String
    property :networks, [String, Array]
    property :log_level, [0, 1, 2], default: 0

    alias_method :v, :log_level

    action :create do
      
      remote_file 'flannel tarball' do
        path "#{file_cache_path}/flannel-0.5.5-linux-amd64.tar.gz"
        source 'https://github.com/coreos/flannel/releases/download/v0.5.5/flannel-0.5.5-linux-amd64.tar.gz'
        checksum '78127e165f124a8f8ddf2391f8b775b3494aec7e693928f78f2328256fe3644c'
      end

      execute 'extract flanneld' do
        command "tar xvf #{tarball_path} -C #{flanneld_bin_prefix} flannel-0.5.5/flanneld --strip-components=1"
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

        variables etcdctl_command: etcdctl_command,
                  flanneld_command: flanneld_command

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

    def flanneld_bin
      ::File.join flanneld_bin_prefix, 'flanneld'
    end

    def flanneld_opts
      opts = []
      opts << "--public_ip=#{public_ip}" unless public_ip.nil?
      opts << "--etcd_endpoints=#{etcd_endpoints}" unless etcd_endpoints.nil?
      opts << "--etcd_prefix=#{etcd_prefix}" unless etcd_prefix == '/coreos.com/network/config'
      opts << "--etcd_keyfile=#{etcd_keyfile}" unless etcd_keyfile.nil?
      opts << "--etcd_cafile=#{etcd_cafile}" unless etcd_cafile.nil?
      opts << "--iface=#{iface}" unless iface.nil?
      opts << "--subnet_file=#{subnet_file}" unless subnet_file == '/run/flannel/subnet.env'
      opts << "--ip_masq=#{ip_masq}" if ip_masq == true
      opts << "--listen=#{listen}" unless listen.nil?
      opts << "--remote=#{remote}" unless remote.nil?
      opts << "--remote_keyfile=#{remote_keyfile}" unless remote_keyfile.nil?
      opts << "--remote_certfile=#{remote_certfile}" unless remote_certfile.nil?
      opts << "--networks=#{networks}" unless networks.nil?
      opts << "--v=#{log_level}" unless log_level == 0
    end

    def flanneld_command
      [flanneld_bin, flanneld_opts].join(' ').strip
    end

    def etcdctl_bin
      '/usr/bin/etcdctl'
    end

    def etcdctl_command
      config = { 'Network' => '10.0.0.0/8' }
      "#{etcdctl_bin} set #{etcd_prefix} '#{config.to_json}'"
    end
  end
end

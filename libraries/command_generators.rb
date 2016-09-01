module FlannelCookbook
  # Helpers to generate invocations of flanneld
  module CommandGenerators
    def flanneld_bin
      ::File.join flanneld_bin_prefix, 'flanneld'
    end

    def flanneld_etcd_authentication_opts
      opts = []
      opts << "--etcd-keyfile=#{etcd_keyfile}" unless etcd_keyfile.nil?
      opts << "--etcd-certfile=#{etcd_certfile}" unless etcd_certfile.nil?
      opts << "--etcd-cafile=#{etcd_cafile}" unless etcd_cafile.nil?
      opts
    end

    def flanneld_etcd_opts
      opts = []
      opts << "--etcd-endpoints=#{etcd_endpoints}" unless etcd_endpoints.nil?
      unless etcd_prefix == self.class.properties[:etcd_prefix].default
        opts << "--etcd-prefix=#{etcd_prefix}"
      end
      opts += flanneld_etcd_authentication_opts
      opts
    end

    def flanneld_client_mode_opts
      opts = []
      opts << "--remote=#{remote}" unless remote.nil?
      opts << "--remote-keyfile=#{remote_keyfile}" unless remote_keyfile.nil?
      opts << "--remote-certfile=#{remote_certfile}" unless remote_certfile.nil?
      opts
    end

    def flanneld_server_mode_opts
      opts = []
      opts << "--listen=#{listen}" unless listen.nil?
      opts
    end

    def flanneld_network_mode_opts
      opts = []
      opts << "--networks=#{networks}" unless networks.nil?
      opts
    end

    def flanneld_interhost_opts
      opts = []
      opts << "--public-ip=#{public_ip}" unless public_ip.nil?
      opts << "--iface=#{iface}" unless iface.nil?
      opts << "--ip-masq=#{ip_masq}" if ip_masq == true
      opts
    end

    def flanneld_subnet_file_opt
      opts = []
      unless subnet_file == self.class.properties[:subnet_file].default
        opts << "--subnet-file=#{subnet_file}"
      end
      opts
    end

    def flanneld_opts
      opts = flanneld_interhost_opts
      opts += flanneld_etcd_opts
      opts += flanneld_subnet_file_opt
      opts += flanneld_server_mode_opts
      opts += flanneld_client_mode_opts
      opts += flanneld_network_mode_opts
      opts << "--v=#{log_level}" unless log_level == 0
      opts
    end

    def flanneld_command
      [flanneld_bin, flanneld_opts].join(' ').strip
    end

    def etcdctl_bin
      '/usr/bin/etcdctl'
    end

    def etcdctl_command
      "#{etcdctl_bin} #{etcdctl_options} set #{etcd_prefix} '#{configuration.to_json}'"
    end
  end
end

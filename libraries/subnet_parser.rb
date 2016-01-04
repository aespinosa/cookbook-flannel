module FlannelCookbook
  module SubnetParser

    def load_subnetfile
      File.read '/run/flannel/subnet.env'
    end

    def subnetfile_subnet
      load_subnetfile.match(/FLANNEL_SUBNET=(.*)$/)[1]
    end

    def subnetfile_mtu
      load_subnetfile.match(/FLANNEL_MTU=(.*)$/)[1]
    end
  end
end

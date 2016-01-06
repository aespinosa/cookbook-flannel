module FlannelCookbook
  module SubnetParser

    def load_subnetfile
      File.read subnet_file
    end

    def subnetfile_subnet
      load_subnetfile.match(/FLANNEL_SUBNET=(.*)$/)[1]
    end

    def subnetfile_mtu
      load_subnetfile.match(/FLANNEL_MTU=(.*)$/)[1]
    end
  end
end

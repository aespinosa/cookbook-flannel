require 'minitest/autorun'
require 'ostruct'

require 'subnet_parser'

module FakeSubnetfile
  def load_subnetfile
    <<-eos.gsub(/^\s+/, '')
      FLANNEL_NETWORK=10.0.0.0/8
      FLANNEL_SUBNET=#{subnet}
      FLANNEL_MTU=#{mtu}
      FLANNEL_IPMASQ=false
    eos
  end
end

class SubnetParserTest < Minitest::Test
  def flannel_resource(options = { subnet: '10.0.34.1/24', mtu: '1472' })
    unless @flannel_resource
      @flannel_resource = OpenStruct.new options
      @flannel_resource.extend FlannelCookbook::SubnetParser
      @flannel_resource.extend FakeSubnetfile
    else
      @flannel_resource
    end
  end

  def test_parsing_the_default_network
    assert_equal '10.0.34.1/24', flannel_resource.subnetfile_subnet
  end

  def test_parsing_the_set_network
    flannel_resource subnet: '10.0.35.1/24'
    assert_equal '10.0.35.1/24', flannel_resource.subnetfile_subnet
  end

  def test_parsing_the_default_mtu
    assert_equal '1472', flannel_resource.subnetfile_mtu
  end

  def test_parsing_the_set_mtu
    flannel_resource mtu: '1500'
    assert_equal '1500', flannel_resource.subnetfile_mtu
  end
end

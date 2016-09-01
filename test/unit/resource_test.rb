require 'chef/resource'

require 'flannel'

require 'minitest/autorun'

class ResourceTest < Minitest::Test
  include FlannelCookbook

  def flannel_service
    Resource.new 'default'
  end

  def test_has_a_name
    assert_equal 'default', flannel_service.name
  end

  def test_default_action_is_create
    assert_equal [:create], flannel_service.action
  end

  def test_default_publicip_is_nil
    assert_nil flannel_service.public_ip
  end

  def test_default_etcd_endpoints_is_nil
    assert_nil flannel_service.etcd_endpoints
  end

  def test_default_etcd_prefix_is_set
    assert_equal '/coreos.com/network/config', flannel_service.etcd_prefix
  end

  def test_default_etcd_keyfile_is_nil
    assert_nil flannel_service.etcd_keyfile
  end

  def test_default_etcd_certfile_is_nil
    assert_nil flannel_service.etcd_certfile
  end

  def test_default_etcd_cafile_is_nil
    assert_nil flannel_service.etcd_cafile
  end

  def test_default_iface_is_nil
    assert_nil flannel_service.iface
  end

  def test_default_subnetfile_is_set
    assert_equal '/run/flannel/subnet.env', flannel_service.subnet_file
  end

  def test_default_ipmasq_is_disabled
    assert_equal false, flannel_service.ip_masq
  end

  def test_default_listen_port_is_nil
    assert_nil flannel_service.listen
  end

  def test_default_remote_is_nil
    assert_nil flannel_service.remote
  end

  def test_default_remote_keyfile_is_nil
    assert_nil flannel_service.remote_keyfile
  end

  def test_default_remote_certfile_is_nil
    assert_nil flannel_service.remote_certfile
  end

  def test_default_networks_is_nil
    assert_nil flannel_service.networks
  end

  def test_default_log_level_is_zero
    assert_equal 0, flannel_service.log_level
  end

  def test_v_flag_aliased_as_log_level
    assert_equal flannel_service.log_level, flannel_service.v
  end
end

require 'chef'

require 'simplecov'
require 'minitest/autorun'

require 'command_generators'
require 'flannel'

class FlanneldCommandTest < Minitest::Test
  def flannel_service(&block)
    @resource ||= begin
      resource = FlannelCookbook::Resource.new 'command test'
      resource.instance_eval(&block) if block
      resource
    end
  end

  def test_default_properties_just_shows_the_binary
    assert_equal '/usr/sbin/flanneld', flannel_service.flanneld_command
  end

  def test_public_ip_is_set
    flannel_service do
      public_ip '127.0.0.1'
    end
    assert_match '--public-ip=127.0.0.1', flannel_service.flanneld_command
  end

  def test_etcd_flags_are_set
    flannel_service do
      etcd_endpoints 'http://127.0.0.1:4001'
      etcd_prefix '/another/prefix'
      etcd_keyfile '/etc/keyfile.pem'
      etcd_cafile '/etc/some-ca-file.pem'
    end
    assert_match '--etcd-endpoints=http://127.0.0.1:4001 '\
        '--etcd-prefix=/another/prefix --etcd-keyfile=/etc/keyfile.pem '\
        '--etcd-cafile=/etc/some-ca-file.pem',
                 flannel_service.flanneld_command
  end

  def test_client_mode_flags_are_set
    flannel_service do
      remote '10.0.0.1:8888'
      remote_keyfile '/etc/keyfile.pem'
      remote_certfile '/etc/certfile.pem'
    end
    assert_match '--remote=10.0.0.1:8888 --remote-keyfile=/etc/keyfile.pem '\
        '--remote-certfile=/etc/certfile.pem',
                 flannel_service.flanneld_command
  end
end

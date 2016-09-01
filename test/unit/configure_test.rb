require 'cheffish/chef_run'

require_relative 'test_helpers'

require 'flannel'

module FakeHelpers
  def etcdctl_command
    'fake etcdctl command'
  end
end

class ConfigureTest < Minitest::Test
  def resource
    run = Cheffish::ChefRun.new
    flannel = nil
    run.compile_recipe do
      flannel = flannel_service 'foo'
    end
    flannel.extend FakeHelpers
    flannel
  end

  def provider
    @provider ||= begin
      provider = resource.provider_for_action(:configure)
      provider.extend ProviderInspection
      provider
    end
  end


  def test_passes_etcd_settings_to_etcdctl
    provider.action_configure
    etcdctl = provider.inline_resources.find 'execute[configure flannel]'
    command = etcdctl.command
    assert_equal 'fake etcdctl command', command
  end

  def test_etcdctl_parameters_are_passed_to_etcdctl
    flannel = FlannelCookbook::Resource.new 'default'
    flannel.etcdctl_options 'any string option'

    assert_match '/usr/bin/etcdctl any string option', flannel.etcdctl_command
  end
end

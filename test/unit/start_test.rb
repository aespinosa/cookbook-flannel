require 'cheffish/chef_run'

require_relative 'test_helpers'

require 'flannel'

module FakeHelpers
  def flanneld_command
    'fake flanneld command'
  end

  def etcdctl_command
    'fake etcdctl command'
  end
end

class StartTest < Minitest::Test
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
      provider = resource.provider_for_action(:start)
      provider.extend ProviderInspection
      provider
    end
  end

  def test_passes_flanneld_command_to_the_systemd_unit
    provider.action_start
    systemd_unit = provider.inline_resources.find 'template[/etc/systemd/system/flannel-foo.service]'
    command = systemd_unit.variables[:flanneld_command]
    assert_equal 'fake flanneld command', command
  end

  def test_passes_etcd_settings_to_the_systemd_unit
    provider.action_start
    systemd_unit = provider.inline_resources.find 'template[/etc/systemd/system/flannel-foo.service]'
    command = systemd_unit.variables[:etcdctl_command]
    assert_equal 'fake etcdctl command', command
  end
end

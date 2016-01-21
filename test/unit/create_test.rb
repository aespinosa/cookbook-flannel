require 'chef'
require 'cheffish/chef_run'

require 'simplecov'
require 'minitest/autorun'

require 'flannel'


module ProviderInspection
  def compile_and_converge_action(&block)
    old_run_context = @run_context
    @run_context = @run_context.create_child
    return_value = instance_eval(&block)
    @inline_run_context = @run_context
    @run_context = old_run_context
    return_value
  end

  def inline_resources
    @inline_run_context.resource_collection
  end
end

class CreateTest < Minitest::Test

  def provider
    if @provider
      @provider
    else
      FlannelCookbook::Resource.action_class.include ProviderInspection
      run = Cheffish::ChefRun.new
      flannel = nil
      run.compile_recipe  do
        flannel = flannel_service 'foo'
      end
      @provider = flannel.provider_for_action(:create)
    end

  end

  def test_downloads_the_tarball
    provider.action_create
    assert_includes provider.inline_resources.keys, 'remote_file[flannel tarball]' 
  end
end

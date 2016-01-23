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

  def assert_creates(resource_collection, resource_name)
    resource = resource_collection.find resource_name
    assert_equal [:create], resource.action,
        "#{resource_name} has the wrong action"
  end

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

  def inline_resources
    provider.inline_resources
  end

  def test_downloads_the_tarball
    provider.action_create
    assert_creates provider.inline_resources, 'remote_file[flannel tarball]'
  end

  def test_extracts_the_tarball_file
    provider.action_create
    extractor = inline_resources.find 'execute[extract flanneld]'
    downloader = inline_resources.find 'remote_file[flannel tarball]'

    assert_match downloader.path, extractor.command
  end
end

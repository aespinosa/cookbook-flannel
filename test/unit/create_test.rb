require 'cheffish/chef_run'

require_relative 'test_helpers'

require 'flannel'

class CreateTest < Minitest::Test

  def assert_creates(resource_collection, resource_name)
    resource = resource_collection.find resource_name
    assert_equal [:create], resource.action,
                 "#{resource_name} has the wrong action"
  end

  def setup
    FlannelCookbook::Resource.action_class.include ProviderInspection
  end

  def provider
    if @provider
      @provider
    else
      run = Cheffish::ChefRun.new
      flannel = nil
      run.compile_recipe do
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

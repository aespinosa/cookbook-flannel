# Flannel Cookbook

This is a library cookbook that provides resources for setting up
[flannel](https://github.com/coreos/flannel) instances.

## Requirements

* Chef 12.5.0 or higher.
* Network accessible web server hosting the flannel binaries.

## Platform Support

Tested on the following platforms with test-kitchen:

* debian-8.2

## Usage

* Add `depends 'flannel', '~> 0.1.0'` to your cookbook's `metadata.rb`.
* Use the resources shipped in this cookbook.

# Custom Resources

* `flannel_service`

## flannel_service

Downloads pre-compiled Go binaries of flanneld onto disk.

* The `:create` action downloads the pre-compiled go binary of flanneld onto
  disk.
* The `:start` action runs flanneld as a systemd service

## Helper

The [libraries/subnet_parser.rb](libraries/subnet_parser.rb) file extends the flannel_service resource to read
and parse the subnet file.  An example approach on integrating with the docker cookbook
is found in
[test/cookbooks/flannel_test/recipes/docker.rb](test/cookbooks/flannel_test/recipes/docker.rb).


# License

Copyright 2016 Allan Espinosa

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

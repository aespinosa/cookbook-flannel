# Flannel Cookbook

This is a library cookbook that provides resources for setting up
[flannel](https://github.com/coreos/flannel) instances.

## Requirements

* Chef 12.5.0 or higher.
* Network accessible web server hosting the flannel binaries.

## Platform Support

Tested on the following platforms with test-kitchen:

* debian-8.4
* centos-7.2
* ubuntu-16.04

## Usage

* Add `depends 'flannel', '~> 0.3'` to your cookbook's `metadata.rb`.
* Use the resources shipped in this cookbook.

# Custom Resources

* `flannel_service`

## flannel_service

Downloads pre-compiled Go binaries of flanneld onto disk.

* The `:create` action downloads the pre-compiled go binary of flanneld onto
  disk.
* The `:configure` action connects to etcd and loads the flanneld configuration to
  it.
* The `:start` action runs flanneld as a systemd service

It has the following properties corresponding to
[flannel's commandline options](https://github.com/coreos/flannel#key-command-line-options)

* `public_ip`
* `etcd_endpoints`
* `etcd_prefix`
* `etcd_keyfile`
* `etcd_certfile`
* `etcd_cafile`
* `iface`
* `subnet_file`
* `ip_masq`
* `listen`
* `remote`
* `remote_keyfile`
* `remote_certfile`
* `networks`
* `v` or `log_level`

Another property called `config` corresponds to
[flannel's etcd-stored configuration](https://github.com/coreos/flannel#configuration)

Additionally, if you are using TLS with etcd, you can pass extra options to the
etcdctl tool using the `etcdctl_options` property

## Helper

The [libraries/subnet_parser.rb](libraries/subnet_parser.rb) file extends the
flannel_service resource to read and parse the subnet file.  An example
approach on integrating with the docker cookbook
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

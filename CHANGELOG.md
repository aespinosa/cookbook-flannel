# 1.1.1

* Add documents and metadata to pass Supermarket quality metrics.

# 1.1.0

* Add etcdctl_options as a resource parameter.

# 1.0.0

* Move out etcd backend configuration to the `:configure` action.

# 0.3.1

* Mostly test and tooling enhancements.
* Fix problem of not invoking flanneld with the proper flags.

# 0.3.0

* Add resource properties to customize flanneld's invocation.

# 0.2.0

* Add `:start` action to launch flannel as a systemd service.
* Provide helpers to parse the subnet file.

# 0.1.0

* Basic layout of the `flannel_service` resource.
* A `:create` action to install flanneld.

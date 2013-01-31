lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant_zfs/version'

Gem::Specification.new do |gem|
  gem.name          = "vagrant-zfs"
  gem.version       = VagrantZFS::VERSION
  gem.authors       = ["JD Harrington"]
  gem.email         = ["jd@jdharrington.net"]

  gem.description   = <<-EOF
    Vagrant-ZFS is a plugin for Vagrant to automate cloning and sharing
    ZFS filesystems from the host machine to a guest VM. This is useful
    for things like bringing up multiple VMs to test database clustering
    without requiring you to manually copy large amounts of data into
    multiple locations on your host or syncing data from host to VMs.

    This project is still in the very early stages, so proceed with caution.
  EOF

  gem.summary       = "A Vagrant plugin to automate cloning and sharing ZFS filesystems with VMs"
  gem.homepage      = "http://github.com/psi/vagrant-zfs"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "zfs"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "vagrant", "1.0.6"
end

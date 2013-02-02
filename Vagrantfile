Vagrant::Config.run do |config|
  config.vm.box     = "opscode_centos_6.3"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_centos-6.3_chef-10.18.2.box"

  config.zfs.share_cloned_folder "vagrant-zfs-test", "/data/vagrant-zfs-test", "vagrant_zfs_test/test"
end

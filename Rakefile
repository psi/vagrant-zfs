require "bundler/gem_tasks"
require "rake/testtask"
require "zfs"

task :default => "test:unit"

Rake::TestTask.new do |t|
  t.name = "test:all"
  t.pattern = "test/**/*_test.rb"
end

Rake::TestTask.new do |t|
  t.name = "test:unit"
  t.pattern = "test/unit/**/*_test.rb"
end

Rake::TestTask.new do |t|
  t.name = "test:integration"
  t.pattern = "test/integration/**/*_test.rb"
end

task "test:integration_setup"    => %w(sandbox:create vagrant:up)
task "test:integration_teardown" => %w(vagrant:destroy sandbox:destroy)

namespace :vagrant do
  desc "Bring test Vagrant VM up"
  task :up do
    system "bundle exec vagrant up"
  end

  desc "Destroy test Vagrant VM"
  task :destroy do
    system "bundle exec vagrant destroy -f"
  end
end

def test_vdev_path
  File.expand_path("../tmp/test_vdev", __FILE__)
end

namespace :sandbox do
  desc "Create a ZFS filesystem for testing"
  task :create do
    # Create a zpool
    sh "mkfile 64m #{test_vdev_path}"
    sh "zpool create vagrant_zfs_test #{test_vdev_path}"
   
    # Create a filesystem
    fs = ZFS("vagrant_zfs_test/test")
    fs.create

    # Populate the filesystem
    sh "touch #{fs.mountpoint}/on_zfs.txt"
  end

  desc "Destroy ZFS filesystem created for testing"
  task :destroy do
    # Destroy the filesystem
    fs = ZFS("vagrant_zfs_test/test")
    fs.destroy!

    # Destroy the zpool

    # With Zevo on OS X 10.8.x, `zpool create` works as a normal user, but
    # `zpool destroy` appears to require root privileges, so we sudo here.
    sh "sudo zpool destroy -f vagrant_zfs_test"
    sh "rm #{test_vdev_path}"
  end
end

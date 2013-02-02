require File.dirname(__FILE__) + "/../test_helper"

describe "When bringing up a VM" do
  before do
    unless $vm_booted
      system "bundle exec rake test:integration_setup"
      $vm_booted = true
    end
  end

  MiniTest::Unit.after_tests do
    system "bundle exec rake test:integration_teardown"
  end

  it "attaches a clone to the VM" do
    assert system("bundle exec vagrant ssh --command 'ls /data/vagrant-zfs-test/on_zfs.txt' >/dev/null")
  end
end

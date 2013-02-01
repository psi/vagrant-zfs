require File.dirname(__FILE__) + "/../spec_helper"

describe "When bringing up a VM" do
  before { system "bundle exec vagrant up >/dev/null" }

  after { system "bundle exec vagrant destroy -f >/dev/null" }

  it "attaches a clone to the VM" do
    assert system("bundle exec vagrant ssh --command 'ls /data/vagrant-zfs-test/on_zfs.txt' >/dev/null")
  end
end


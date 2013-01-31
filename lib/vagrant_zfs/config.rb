module VagrantZFS
  class Config < Vagrant::Config::Base
    def share_cloned_folder(name)
      puts ">>>> #{name}"
    end
  end
end

Vagrant.config_keys.register(:zfs) { VagrantZFS::Config }

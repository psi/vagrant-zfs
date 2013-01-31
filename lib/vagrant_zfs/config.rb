module VagrantZFS
  class Config < Vagrant::Config::Base
    attr_accessor :cloned_folders

    def cloned_folders
      @cloned_folders ||= {}
    end

    def share_cloned_folder(name, guestpath, filesystem, options = {})
      self.cloned_folders[name] = {
        :guestpath  => guestpath,
        :filesystem => filesystem,
        :options    => options
      }
    end
  end
end

Vagrant.config_keys.register(:zfs) { VagrantZFS::Config }

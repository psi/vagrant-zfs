module VagrantZFS
  module Middleware
    class CloneZFS
      def initialize(app, env)
        @app = app
      end

      def call(env)
        uuid = env[:vm].uuid

        env[:vm].config.zfs.cloned_folders.each do |name, data|
          snapshot_name  = "#{data[:filesystem]}@#{uuid}"
          new_filesystem = "#{data[:filesystem]}-#{uuid}"

          system "zfs snapshot #{snapshot_name}"
          system "zfs clone #{snapshot_name} #{new_filesystem}"

          env[:vm].config.vm.share_folder name, data[:guestpath], "/Volumes/#{new_filesystem}", data[:options]
        end

        @app.call(env)
      end
    end
  end
end

Vagrant.actions[:start].insert_before Vagrant::Action::VM::ShareFolders,
                                      VagrantZFS::Middleware::CloneZFS

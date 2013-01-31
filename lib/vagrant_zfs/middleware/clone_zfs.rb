module VagrantZFS
  module Middleware
    class CloneZFS
      def initialize(app, env)
        @app = app
      end

      def call(env)
        uuid = env[:vm].uuid

        env[:vm].config.zfs.cloned_folders.each do |name, data|
          source_fs = ZFS(data[:filesystem])

          snapshot = source_fs.snapshot(uuid)
          new_fs = snapshot.clone!("#{data[:filesystem]}-#{uuid}")

          env[:vm].config.vm.share_folder name, data[:guestpath], new_fs.mountpoint, data[:options]
        end

        @app.call(env)
      end
    end
  end
end

Vagrant.actions[:start].insert_before Vagrant::Action::VM::ShareFolders,
                                      VagrantZFS::Middleware::CloneZFS

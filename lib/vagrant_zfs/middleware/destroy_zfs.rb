module VagrantZFS
  module Middleware
    class DestroyZFS
      def initialize(app, env)
        @app = app
        @env = env
      end

      def call(env)
        uuid = @env[:vm].uuid

        env[:vm].config.zfs.cloned_folders.each do |name, data|
          new_fs = ZFS("#{data[:filesystem]}-#{uuid}")
          snapshot = new_fs.origin

          new_fs.destroy!
          snapshot.destroy!
        end

        @app.call(env)
      end
    end
  end
end

Vagrant.actions[:destroy].insert_before Vagrant::Action::VM::Destroy,
                                        VagrantZFS::Middleware::DestroyZFS

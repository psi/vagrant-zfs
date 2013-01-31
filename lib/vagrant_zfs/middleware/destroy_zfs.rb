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
          snapshot_name  = "#{data[:filesystem]}@#{uuid}"
          new_filesystem = "#{data[:filesystem]}-#{uuid}"

          system "zfs destroy #{new_filesystem}"
          system "zfs destroy #{snapshot_name}"
        end

        @app.call(env)
      end
    end
  end
end

Vagrant.actions[:destroy].insert_before Vagrant::Action::VM::Destroy,
                                        VagrantZFS::Middleware::DestroyZFS

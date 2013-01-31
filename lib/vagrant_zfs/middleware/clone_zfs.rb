module VagrantZFS
  module Middleware
    class CloneZFS
      def initialize(app, env)
        @app = app
        @env = env
      end

      def call(env)
        uuid = @env[:vm].uuid
        system "zfs snapshot mypool/mysql@#{uuid}"
        system "zfs clone mypool/mysql@#{uuid} mypool/mysql-vagrant-#{uuid}"

        @env[:vm].config.vm.share_folder "mysql", "/data/mysql", "/Volumes/mypool/mysql-vagrant-#{uuid}"

        @app.call(env)
      end
    end
  end
end

Vagrant.actions[:start].insert_before Vagrant::Action::VM::ShareFolders,
                                      VagrantZFS::Middleware::CloneZFS

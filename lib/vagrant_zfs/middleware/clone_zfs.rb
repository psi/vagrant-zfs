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

        @env[:vm].config.vm.share_folder "mysql", "/data/mysql", "/Volumes/mypool/mysql-vagrant-#{uuid}", :owner => "mysql", :group => "mysql"

        @app.call(env)
      end
    end
  end
end

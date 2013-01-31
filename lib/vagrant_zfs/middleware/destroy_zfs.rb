module VagrantZFS
  module Middleware
    class DestroyZFS
      def initialize(app, env)
        @app = app
        @env = env
      end

      def call(env)
        uuid = @env[:vm].uuid

        system "zfs destroy mypool/mysql-vagrant-#{uuid}"
        system "zfs destroy mypool/mysql@#{uuid}"

        @app.call(env)
      end
    end
  end
end

Vagrant.actions[:destroy].insert_before Vagrant::Action::VM::Destroy,
                                        VagrantZFS::Middleware::DestroyZFS

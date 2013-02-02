# Vagrant-ZFS

Vagrant-ZFS is a plugin for [Vagrant][1] to automate cloning and sharing
ZFS filesystems from the host machine to a guest VM. This is useful for
things like bringing up multiple VMs to test database clustering without
requiring you to manually copy large amounts of data into multiple
locations on your host machine or syncing data from host to VMs.

This project is still in the very early stages, so proceed with caution.

## Using Vagrant-ZFS in your project

1. Install the vagrant-zfs gem into Vagrant's isolated environment.

    ```
    $ vagrant gem install vagrant-zfs
    ```

2. Configure filesystems to be cloned and shared in your Vagrantfile.

    ```ruby
    Vagrant::Config.run do |config|
      ...
      
      logical_name = "mysql"
      guest_path   = "/data/mysql"
      zfs_name     = "mysql/baseline" # Expects pool/filesystem_name
 
      config.zfs.share_cloned_folder logical_name, guest_path, zfs_name

      ...
    end
    ``` 

## Trying out Vagrant-ZFS

1. Make sure you have ZFS. On OS X, you can install [Zevo][2].
2. You'll also need [VirtualBox][3] and [Vagrant][1] installed.
3. Get the vagrant-zfs repository.

    ```
    $ git clone https://github.com/psi/vagrant-zfs
    $ cd vagrant-zfs
    $ bundle install
    ```

4. Create a sandbox zpool and filesystem.

    ```
    $ bundle exec rake sandbox:create
    ```

5. Bring up a test VM.

    ```
    $ bundle exec vagrant up
    $ bundle exec vagrant ssh
    ```
    
   Take a look in /data/vagrant-zfs-test on the VM and you'll
   see the on_zfs.txt file that we touched earlier.
   
   Now, exit the VM and check out what's been done.
   
    ``` 
    $ zfs list | grep vagrant_zfs_test/test
    vagrant_zfs_test/test                                       33.5Ki 27.2Mi  33.5Ki  /Volumes/vagrant_zfs_test/test
    vagrant_zfs_test/test-94813591-df75-4cc9-8067-faaaff291bd7     1Ki 27.2Mi  33.5Ki  /Volumes/vagrant_zfs_test/test-94813591-df75-4cc9-8067-faaaff291bd7
    ```
    
   Notice the original filesystem you created and the cloned filesystem
   that is now attached to the VM. The UUID of the Vagrant instance is
   appended to the clone name so you can bring up multiple VMs, each with
   their own clone of the original filesystem.
    
6. Destroy your VM and cleanup

    ```
    $ bundle exec vagrant destroy
    
    $ zfs list | grep vagrant_zfs_test/test
    vagrant_zfs_test/test    33.5Ki  27.1Mi  33.5Ki /Volumes/vagrant_zfs_test/test
    
    # Destroying the VM also destroys the cloned filesystem and the snapshot
    # that was used to make it so you won't end up with tons of crufty clones.

    $ bundle exec rake sandbox:destroy
    ```

[1]: http://www.vagrantup.com/
[2]: http://getgreenbytes.com/solutions/zevo/
[3]: https://www.virtualbox.org/

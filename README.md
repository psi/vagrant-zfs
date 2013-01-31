# Vagrant-ZFS

Vagrant-ZFS is a plugin for [Vagrant][1] to automate cloning and sharing
ZFS filesystems from the host machine to a guest VM. This is useful for
things like bringing up multiple VMs to test database clustering without
requiring you to manually copy large amounts of data into multiple
locations on your host machine or syncing data from host to VMs.

This project is still in the very early stages, so proceed with caution.

## Trying out Vagrant-ZFS

In the future, Vagrant-ZFS will be released as a gem plugin for Vagrant.

Until then...

1. Make sure you have ZFS. On OS X, you can install [Zevo][2].
2. You'll also need [VirtualBox][3] and [Vagrant][1] installed.
3. Create a zpool and a ZFS filesystem.

    ```
    $ mkfile 1g /tmp/zfs_vdev
    $ zpool create mypool /tmp/zfs_vdev
    $ zfs create mypool/vagrant-zfs-test
    $ touch /Volumes/mypool/vagrant-zfs-test/on_zfs.txt
    ```
4. Get the vagrant-zfs repository and bring up a test VM

    ```
    $ git clone https://github.com/psi/vagrant-zfs
    $ cd vagrant-zfs
    $ bundle install
    $ bundle exec vagrant up
    $ bundle exec vagrant ssh
    
    # Take a look in /data/vagrant-zfs-test on the VM and you'll
    # see the on_zfs.txt file that we touched earlier.
    #
    # Now, exit the VM...
    
    $ zfs list | grep mypool/vagrant-zfs-test
    mypool/vagrant-zfs-test                                       33.5Ki   962Mi  33.5Ki  /Volumes/mypool/vagrant-zfs-test
    mypool/vagrant-zfs-test-1afdbf7a-d861-4a26-b4c3-358f7c4b6a79     1Ki   962Mi  33.5Ki  /Volumes/mypool/vagrant-zfs-test-1afdbf7a-d861-4a26-b4c3-358f7c4b6a79
    
    # Notice the original filesystem you created and the cloned filesystem
    # that is now attached to the VM. The UUID of the Vagrant instance is
    # appended to the clone name so you can bring up multiple VMs, each with
    # their own clone of the original filesystem.
    ```
    
5. Destroy your VM and cleanup

    ```
    $ bundle exec vagrant destroy
    
    $ zfs list | grep mypool/vagrant-zfs-test
    mypool/vagrant-zfs-test  33.5Ki   962Mi  33.5Ki  /Volumes/mypool/vagrant-zfs-test
    
    # Destroying the VM also destroys the cloned filesystem and the snapshot
    # that was used to make it so you won't end up with tons of crufty clones.
    ```


[1]: http://www.vagrantup.com/
[2]: http://getgreenbytes.com/solutions/zevo/
[3]: https://www.virtualbox.org/

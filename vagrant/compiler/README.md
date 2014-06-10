MLab-Compiler Vagrant
============

The vagrant setup for the compiler.

1. Install vagrant. Go to http://www.vagrantup.com
2. Install virtualbo https://www.virtualbox.org
3. Change directory to the compiler-vagrant folder within the project
4. Run `Vagrant up`. This will take around 15 minutes. If it fails with a timeout, run the command again.
5. Run `vagrant ssh` to login to the server.
6. The compiler runs every 5 minutes and looks for uncompiled applications
7. Put uncompiled applications in MLab-Vagrant/app-working-folder/queue
8. When the application is compiled it appears in MLab-Vagrant/app-working-folder/compiled folder.
9. Shutdown the vagrant box by running `vagrant halt`
10. Read more about using Vagrant here https://github.com/SyscoAS/MLab-Vagrant/blob/develop/README.md

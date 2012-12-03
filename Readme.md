# Windows from scratch


Download this repo and install the gems from the Gemfile.

    git clone git://github.com/hh/windows-fromscratch.git
    cd windows-fromscratch
    bundle install

Now generate a new windows 2008R2 box from scratch.

    # vagrant box remove windows-2008R2-serverstandard-amd64-winrm
    veewee vbox build windows-2008R2-serverstandard-amd64-winrm
    veewee vbox validate windows-2008R2-serverstandard-amd64-winrm
    vagrant basebox export windows-2008R2-serverstandard-amd64-winrm

    # optionally install (force) the new box
    vagrant box add -f windows-2008R2-serverstandard-amd64-winrm ./windows-2008R2-serverstandard-amd64-winrm.box

    # this will use the basebox we just built
    vagrant up


## winrm ??
need to add chef to gemset, aand alias ?

    knife winrm -m 127.0.0.1 -P 5986 -x vagrant -P vagrant COMMAND

# TODO

* cleanup 1.9.2@global (veewee is there ..)
* why are we using specific versions (git) of veewee, en-winrm
* split up the veewee basebox (use main distro), and vagrant stuff

## Ruby and RVM

    rvm install 1.9.2
    gem install bundler

    # if you want to empty the gemset...
    rvm gemset empty vagrantwin
    # or
    rvm gemset delete mygemset
    rvm gemset create mygemset


Use .rvmrc to use ruby 1.9.2@vagrantwin

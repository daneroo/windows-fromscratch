# Windows from scratch

## TODO: sql express

* try original Config.
* merge in dim's settings
* start the recipe from scratch in vagrant sas
* install tiny_tds and restore database... (if not exists)
* use annoyances,bginfo,...


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

Now generate a new windows 2008R2 box w/SQLEXPRESS.

    # vagrant box remove windows-2008R2-SQLEXPRESS-winrm
    veewee vbox build windows-2008R2-SQLEXPRESS-winrm
    veewee vbox validate windows-2008R2-SQLEXPRESS-winrm
    vagrant basebox export windows-2008R2-SQLEXPRESS-winrm

    # optionally install (force) the new box
    vagrant box add -f windows-2008R2-SQLEXPRESS-winrm ./windows-2008R2-SQLEXPRESS-winrm.box

    # this will use the basebox we just built
    vagrant up

Now generate a new windows 2012 box from scratch. (not done yet)

    # vagrant box remove windows-2012
    veewee vbox build windows-2012
    veewee vbox validate windows-2012
    vagrant basebox export windows-2012


## winrm ??
need to add chef to gemset, aand alias ?

    knife winrm -m 127.0.0.1 -P 5986 -x vagrant -P vagrant COMMAND

## Ruby and RVM

    rvm install 1.9.2
    gem install bundler

    # if you want to empty the gemset...
    rvm gemset empty vagrantwin
    # or
    rvm gemset delete mygemset
    rvm gemset create mygemset


Use .rvmrc to use ruby 1.9.2@vagrantwin

# TODO

* cleanup 1.9.2@global (veewee is there ..)
* why are we using specific versions (git) of veewee, en-winrm
* why do opscode recipes not work like hh's : _annoyances -> windows?
* split up the veewee basebox (use main distro), and vagrant stuff

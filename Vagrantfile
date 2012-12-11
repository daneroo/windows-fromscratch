Vagrant::Config.run do |config|

  #The following timeout configuration is option, however if have
  #any large remote_file resources in your chef recipes, you may
  #experience timeouts (reported as 500 responses)
  config.winrm.timeout = 1800     #Set WinRM Timeout in seconds (Default 30)

  # Configure base box parameters
  config.vm.box = "windows-2008R2-serverstandard-amd64-winrm"
  config.vm.box_url = "./windows-2008R2-serverstandard-amd64-winrm.box"
  # config.vm.box = "windows-2008R2-SQLEXPRESS-winrm"
  # config.vm.box_url = "./windows-2008R2-SQLEXPRESS-winrm.box"
  config.vm.guest = :windows
  config.vm.boot_mode = :gui

  config.vm.forward_port 3389, 3390, :name => "rdp", :auto => true
  config.vm.forward_port 5985, 5985, :name => "winrm", :auto => true
  config.vm.forward_port 1433, 1433, :name => "mssql", :auto => true
  config.vm.forward_port 80, 8080, :name => "http", :auto => true

  config.vm.customize ["modifyvm", :id, "--memory", 2048]
  config.vm.customize ["modifyvm", :id, "--cpuexecutioncap", 80]
  config.vm.customize ["modifyvm", :id, "--vram", 48] # I have a big screen
  config.vm.customize ["modifyvm", :id, "--cpus", 4] # I have a 4 way

  # network
  # config.vm.network :hostonly, "192.168.20.10"
  # config.vm.network :bridged
  # config.vm.network :bridged, { bridge: 'en0: Ethernet' }

  # shares
  # config.vm.share_folder "foo", "/guest/path", "/host/path"
  # config.vm.share_folder "cache", "c:\\cache", "./cache"

  config.vm.provision :chef_solo do |chef|
    # chef.cookbooks_path =  ["cookbooks", "opscodecookbooks"]
    chef.cookbooks_path =  ["cookbooks", "hhcookbooks"]
    # chef.json.merge!({:mykey =>"myvalue"})
    chef.json.merge!({:sql_server => {
      :accept_eula => true,
      :server_sa_password => 's0l0DB$',
      :instance_name => 'SOLOCHAIN'
    }})
    chef.add_recipe("windows::reboot_handler")
    chef.add_recipe("windows-fromscratch::_annoyances")
    chef.add_recipe("windows-fromscratch::sysinternals")
    chef.add_recipe("windows-fromscratch::bginfo")

    chef.add_recipe("windows-fromscratch::vagrant_preseed")

    chef.add_recipe("windows-fromscratch::packages")
    # chef.add_recipe("windows-fromscratch::forcereboot")

    chef.add_recipe("windows-fromscratch::sql_server_install")
    # sql_server from opscode does not work from winrm
    # chef.add_recipe("sql_server::server")

    chef.add_recipe("windows-fromscratch::restore_database")
  end # unless true

end

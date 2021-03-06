# The MS-SQL-Installer does not work from winrm,
# But we have found that scheduling a task with schtasks, and executing it immediately works.

# TODO: 
#   move to its own recipe (with template)
#   guard installer for idempotence
#   re-use the template file from opscode sql_server
#   find a way to determine when the installation is done, then trigger a service restart
#   net stop <svcname>; net start <svcname>

cache_path = Chef::Config[:file_cache_path]

# fetch Microsoft SQL Server 2008 R2 (64-bit)
remote_file win_friendly_path("#{cache_path}/SQLEXPR_x64_ENU.exe") do
  source 'http://care.dlservice.microsoft.com/dl/download/5/1/A/51A153F6-6B08-4F94-A7B2-BA1AD482BC75/SQLEXPR_x64_ENU.exe'
  checksum '6840255cf493927a3f5e1d7f865b8409ed89133e3657a609da229bab4005b613'
  action :create_if_missing
end

# fetch Microsoft SQL Server 2008 R2 With Tools (64-bit)
remote_file  win_friendly_path("#{cache_path}/SQLEXPRWT_x64_ENU.exe") do
  source 'http://download.microsoft.com/download/5/5/8/558522E0-2150-47E2-8F52-FF4D9C3645DF/SQLEXPRWT_x64_ENU.exe'
  checksum 'c2210394515a96dba37b88ea3b1e87659aa5984026ab97d0eaa63e7ae42f6f1b'
  action :create_if_missing
end

# installer w/tools
windows_batch "sql installer task" do
  code <<-EOH
  schtasks /Create /tn "sqlexpr_install" /tr "#{cache_path}\\SQLEXPRWT_x64_ENU.exe /q /HIDECONSOLE /ConfigurationFile=c:\\vagrant\\ConfigurationFileWTools.ini" /sc once /st 00:01 /sd 05/16/2020 /f /rl HIGHEST
  schtasks /Run /tn "sqlexpr_install"
  EOH
  not_if { File.directory?('c:\\Program Files\\Microsoft SQL Server') }
end


# max 15 minutes...
windows_batch "wait for install to finish" do
  code <<-EOH
  powershell $i=0; while ($i -le 900) { if (Get-Service 'mssql$solochain' -ErrorAction SilentlyContinue){echo "FOUND";break} else {echo "WAITING"}; $i++; sleep 1}
  sleep 10
  EOH
end

# Can remove the task now...
# Disabling the task makes it unexecutable...
# schtasks /Change /tn "sqlexpr_install" /Disable
windows_batch "remove sql installer task" do
  code <<-EOH
  schtasks /Delete /tn "sqlexpr_install" /f
  EOH
  not_if { File.directory?('c:\\Program Files\\Microsoft SQL Server') }
end

service_name = "MSSQL$#{node['sql_server']['instance_name']}"
service service_name do
  action :nothing
end

# guard for idempotence ? 
windows_batch "open sql port" do
  code <<-EOH
  netsh advfirewall firewall add rule name="MSSQL 1433" dir=in action=allow protocol=TCP localport=1433
  EOH
end

# set the static tcp port (if necessary)
key_name = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10_50.' << node['sql_server']['instance_name'] << '\MSSQLServer\SuperSocketNetLib\Tcp\IPAll'
port_s = node['sql_server']['port'].to_s
windows_registry "set-static-tcp-port"  do
  key_name key_name
  values 'TcpPort' => port_s, 'TcpDynamicPorts' => ""
  action :force_modify
  notifies :restart, "service[#{service_name}]", :immediately
  not_if { port_s == Registry.get_value(key_name,'TcpPort') }
end


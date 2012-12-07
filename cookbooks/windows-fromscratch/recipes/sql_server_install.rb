# The MS-SQL-Installer does not work from winrm,
# But we have found that scheduling a task with schtasks, and executing it immediately works.

# TODO: 
#   move to its own recipe (with template)
#   guard installer for idempotence
#   re-use the template file from opscode sql_server
#   find a way to determine when the installation is done, then trigger a service restart
#   net stop <svcname>; net start <svcname>


# Microsoft SQL Server 2008 R2 (64-bit)
# This does not work from winrm
windows_package "Microsoft SQL Server 2008 R2 (64-bit)" do
  source 'http://care.dlservice.microsoft.com/dl/download/5/1/A/51A153F6-6B08-4F94-A7B2-BA1AD482BC75/SQLEXPR_x64_ENU.exe'
  checksum '6840255cf493927a3f5e1d7f865b8409ed89133e3657a609da229bab4005b613'
  installer_type :custom
  options "/q /ConfigurationFile=c:\\vagrant\\ConfigurationFile.ini"
  action :nothing
end


# fetch Microsoft SQL Server 2008 R2 (64-bit)
remote_file "SQLEXPR_x64_ENU.exe" do
  source 'http://care.dlservice.microsoft.com/dl/download/5/1/A/51A153F6-6B08-4F94-A7B2-BA1AD482BC75/SQLEXPR_x64_ENU.exe'
  checksum '6840255cf493927a3f5e1d7f865b8409ed89133e3657a609da229bab4005b613'
  action :create_if_missing
end


# schtasks /Change /tn "sqlexpr_install" /Disable
# schtasks /Delete /tn "sqlexpr_install"
windows_batch "sql installer task" do
  code <<-EOH
  schtasks /Create /tn "sqlexpr_install" /tr "c:\\SQLEXPR_x64_ENU.exe /q /HIDECONSOLE /ConfigurationFile=c:\\vagrant\\ConfigurationFile.ini" /sc once /st 00:01 /sd 05/16/2020 /f /rl HIGHEST
  schtasks /Run /tn "sqlexpr_install"
  schtasks /Delete /tn "sqlexpr_install"
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

service_name = "MSSQL$#{node['sql_server']['instance_name']}"

service service_name do
  action :nothing
end

windows_batch "open sql port" do
  code <<-EOH
  netsh advfirewall firewall add rule name="MSSQL 1433" dir=in action=allow protocol=TCP localport=1433
  EOH
end

# set the static tcp port
windows_registry "set-static-tcp-port"  do
  key_name 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10_50.' << node['sql_server']['instance_name'] << '\MSSQLServer\SuperSocketNetLib\Tcp\IPAll'
  values 'TcpPort' => node['sql_server']['port'].to_s, 'TcpDynamicPorts' => ""
  action :force_modify
  notifies :restart, "service[#{service_name}]", :immediately
end



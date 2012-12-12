# this will restore an initial solochain database

cache_path = win_friendly_path(Chef::Config[:file_cache_path])

sql_server_database 'solochain' do
  connection ({:host => "127.0.0.1", :port => node['sql_server']['port'], :username => 'sa', :password => node['sql_server']['server_sa_password']})
  action :create
end unless true

# this section restores the database

windows_batch "unzip db snapshot" do
  code <<-EOH
  cd #{cache_path}
  "c:\\Program Files\\7-Zip\\7z.exe" x -y Dominos-03-Aug-2012.7z
  EOH
end

# wait a bit for mssql to be restarted, before restoring
# http://www.howtogeek.com/50295/backup-your-sql-server-database-from-the-command-line/
windows_batch "restore snapshot" do
  code <<-EOH
  sleep 10
  "c:\\Program Files\\Microsoft SQL Server\\100\\Tools\\Binn\\SQLCMD.exe" -S 127.0.0.1 -U sa -P s0l0DB$ -Q "RESTORE DATABASE [solochain] FROM  DISK = N'C:\\tmp\\vagrant-chef-1\\solochain-03-Aug-2012.bak' WITH  FILE = 1,  MOVE N'solocorp' TO N'c:\\sqldata\\solochain.mdf',  MOVE N'solocorp_log' TO N'c:\\sqllogs\\solochain.ldf',  NOUNLOAD,  STATS = 10"
  EOH
end

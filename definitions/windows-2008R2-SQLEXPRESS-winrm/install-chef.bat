cscript %TEMP%\wget.vbs /url:http://www.opscode.com/chef/install.msi /path:%TEMP%\chef-client.msi
msiexec /qn /i %TEMP%\chef-client.msi

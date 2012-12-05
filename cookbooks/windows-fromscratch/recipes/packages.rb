
# Install features (and other packages...)

windows_feature "NetFx3" do
  action :install
end

# install 7-Zip (MSI installer)
windows_package "7-Zip 9.20 (x64 edition)" do
  source "http://downloads.sourceforge.net/sevenzip/7z920-x64.msi"
  action :install
end

# Google Chrome FTW (MSI installer)
windows_package "Google Chrome" do
  source "https://dl-ssl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B806F36C0-CB54-4A84-A3F3-0CF8A86575E0%7D%26lang%3Den%26browser%3D3%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dfalse/edgedl/chrome/install/GoogleChromeStandaloneEnterprise.msi"
  action :install
end

# Microsoft SQL Server 2008 R2 (64-bit)
windows_package "Microsoft SQL Server 2008 R2 (64-bit)" do
  source 'http://care.dlservice.microsoft.com/dl/download/5/1/A/51A153F6-6B08-4F94-A7B2-BA1AD482BC75/SQLEXPR_x64_ENU.exe'
  # checksum '6840255cf493927a3f5e1d7f865b8409ed89133e3657a609da229bab4005b613'
  installer_type :custom
  options "/q /ConfigurationFile=c:\\vagrant\\ConfigurationFile.ini"
  action :nothing
end

windows_batch "sql installer" do
  code <<-EOH
  c:\\SQLEXPR_x64_ENU.exe /q /ConfigurationFile=c:\\ConfigurationFile.ini 
  EOH
end

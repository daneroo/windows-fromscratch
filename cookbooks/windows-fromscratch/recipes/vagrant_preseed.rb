# because we can't seem to use remote_file into vbox shared folders:

cache_src = "vagrant/cache" # c:\vagrant\cache
# cache_dest = win_friendly_path(Chef::Config[:file_cache_path])
cache_dest = Chef::Config[:file_cache_path]

Chef::Log.info("preseed cache src:#{cache_src} dst:#{cache_dest}")

preseed_packages = [
    "7z920-x64.msi",
    "npp.6.2.2.Installer.exe",
    "GoogleChromeStandaloneEnterprise.msi",
    "SQLEXPR_x64_ENU.exe",
    "SQLEXPRWT_x64_ENU.exe",
    "Dominos-03-Aug-2012.7z",
    "SAS-Setup.20121017.exe"
];

ruby_block 'preseed cache section' do
    block do
        Chef::Log.info("preseed cache src:#{cache_src} dst:#{cache_dest}")
        preseed_packages.each do |fname|
            src = "#{cache_src}/#{fname}"
            dst = "#{cache_dest}/#{fname}"
            if (File.exists?(src) && ! File.exists?(dst))
                puts("Copying... #{src} -> #{dst}" )
                FileUtils.cp src, dst
            else
                puts("Skipping... #{src} -> #{dst}" )
            end
        end
    end
end

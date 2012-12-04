
include_recipe 'windows::reboot_handler'
# we want to do this on first boot only...
Chef::Log.info('Will force reboot: #{any_of_theese}')
windows_reboot 60 do
  reason 'cause chef said so'
  action :request
end
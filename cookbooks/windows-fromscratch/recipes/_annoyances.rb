# http://technet.microsoft.com/en-us/library/cc732131.aspx
# Look upnder Registry settings

any_of_theese=false

if 1 != Registry.get_value('HKLM\SOFTWARE\Microsoft\ServerManager\Oobe','DoNotOpenInitialConfigurationTasksAtLogon')
    windows_registry 'HKLM\SOFTWARE\Microsoft\ServerManager\Oobe' do
      values 'DoNotOpenInitialConfigurationTasksAtLogon' => 1
    end
    any_of_theese=true
end

if 1 != Registry.get_value('HKLM\SOFTWARE\Microsoft\ServerManager','DoNotOpenServerManagerAtLogon')
    windows_registry 'HKLM\SOFTWARE\Microsoft\ServerManager' do
      values 'DoNotOpenServerManagerAtLogon' => 1
    end
    any_of_theese=true
end

# http://technet.microsoft.com/en-us/library/cc778526(v=ws.10).aspx#w2k3tr_set_tools_zgjt
windows_registry 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Reliability' do
  values 'ShutdownReasonUI' => 0, 'ShutdownReasonOn' => 0
end

# http://technet.microsoft.com/en-us/library/dd835564(v=ws.10).aspx#BKMK_AdminApprovalMode
# http://technet.microsoft.com/en-us/library/dd835564(v=ws.10).aspx#BKMK_RegistryKeys
if 0 != Registry.get_value('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System','EnableLUA')
    windows_registry 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' do
      values 'EnableLUA' => 0
    end
    any_of_theese=true
end

Chef::Log.info('Will force reboot: #{any_of_theese}')
if any_of_theese
    windows_reboot 60 do
      reason 'after fixing annoyances'
      action :request
    end
end
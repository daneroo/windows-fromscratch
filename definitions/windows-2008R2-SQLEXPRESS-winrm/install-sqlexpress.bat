REM Install SQLExpress (and .Net3.5 )

REM Commented Install .Net (not sure this is actually required)
REM dism /online /enable-feature /FeatureName:NetFx3 /NoRestart

REM Fetch SQLEXPR_x64 (can also get the version w/Tools)
REM http://download.microsoft.com/download/5/5/8/558522E0-2150-47E2-8F52-FF4D9C3645DF/SQLEXPRWT_x64_ENU.exe
cscript %TEMP%\wget.vbs /url:http://care.dlservice.microsoft.com/dl/download/5/1/A/51A153F6-6B08-4F94-A7B2-BA1AD482BC75/SQLEXPR_x64_ENU.exe /path:%TEMP%\SQLEXPR_x64_ENU.exe

REM We can't run the installer through winrm, but we can schedule a task to do it: tadaa
schtasks /Create /tn "sqlexpr_install" /tr "%TEMP%\SQLEXPR_x64_ENU.exe /q /ConfigurationFile=a:\ConfigurationFile.ini" /sc once /st 00:01 /sd 05/16/2020 /f /rl HIGHEST
schtasks /Run /tn "sqlexpr_install"

REM WAIT for installation task
powershell $i=0; while ($i -le 900) { if (Get-Service 'mssql$solochain' -ErrorAction SilentlyContinue){echo "FOUND";break} else {echo "WAITING: $i"}; $i++; sleep 1}
sleep 30

schtasks /Delete /tn "sqlexpr_install" /f

REM Open firewall
netsh advfirewall firewall add rule name="MSSQL 1433" dir=in action=allow protocol=TCP localport=1433

REM Open tcp port on mssql$solochain
REM REG QUERY KeyName [/v ValueName | /ve] [/s]
REM REG QUERY "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10_50.MSSQL$SOLOCHAIN\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" /v TcpPort
REG ADD "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10_50.MSSQL$SOLOCHAIN\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" /v TcpPort /t REG_SZ /d "1433" /f

REM Prevent UAC - EnableLUA=0
REM Thi should probably be elsewhere (fix-annoyances.bat)
REM REG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d "0" /f

REM Restart mssql service
REM service stop, service start ... 
REM not really necessary to restart, we are just installing
REM cmd /C net stop 'MSSQL$SOLOCHAIN'
REM cmd /C net start 'MSSQL$SOLOCHAIN'


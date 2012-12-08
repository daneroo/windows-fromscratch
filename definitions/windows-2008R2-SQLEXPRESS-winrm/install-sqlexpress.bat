REM Install SQLExpress (and .Net3.5 )

REM Install .Net (not sure this is actually required)
cmd /C dism /online /enable-feature /FeatureName:NetFx3 /NoRestart
cmd /C cscript %TEMP%\wget.vbs /url:http://care.dlservice.microsoft.com/dl/download/5/1/A/51A153F6-6B08-4F94-A7B2-BA1AD482BC75/SQLEXPR_x64_ENU.exe /path:%TEMP%\SQLEXPR_x64_ENU.exe

REM We can't run the installer through winrm, but we can schedule a task to do it: tadaa
cmd /C schtasks /Create /tn "sqlexpr_install" /tr "%TEMP%\SQLEXPR_x64_ENU.exe /q /ConfigurationFile=a:\ConfigurationFile.ini" /sc once /st 00:01 /sd 05/16/2020 /f /rl HIGHEST
cmd /C schtasks /Run /tn "sqlexpr_install"

REM WAIT for installation task
cmd /C powershell $i=0; while ($i -le 900) { if (Get-Service 'mssql$solochain' -ErrorAction SilentlyContinue){echo "FOUND";break} else {echo "WAITING: $i"}; $i++; sleep 1}
cmd /C sleep 30

REM cmd /C schtasks /Delete /tn "sqlexpr_install" /f

REM Open firewall
cmd /C netsh advfirewall firewall add rule name="MSSQL 1433" dir=in action=allow protocol=TCP localport=1433

REM Open tcp port on mssql$solochain
REM REG QUERY KeyName [/v ValueName | /ve] [/s]
REM REG QUERY "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10_50.MSSQL$SOLOCHAIN\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" /v TcpPort
cmd /C REG ADD "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10_50.MSSQL$SOLOCHAIN\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" /v TcpPort /t REG_SZ /d "1433" /f

REM Restart mssql service
REM service stop, service start ... 
REM not really necessary to restart, we are just installing
REM cmd /C net stop 'MSSQL$SOLOCHAIN'
REM cmd /C net start 'MSSQL$SOLOCHAIN'
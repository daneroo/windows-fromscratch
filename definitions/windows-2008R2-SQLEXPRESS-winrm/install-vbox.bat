REM with this, we can open the iso, and extract the VBoxWindowsAdditions.exe!
REM http://downloads.sourceforge.net/sevenzip/7z920.exe
certutil -addstore -f "TrustedPublisher" a:oracle-cert.cer
e:\VBoxWindowsAdditions-amd64.exe /S
shutdown /r /t 10  /f /d p:4:1 /c "Restarting for VBoxWindowsAdditions"

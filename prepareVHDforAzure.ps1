# Prepare Azure VHD
#Powershell script with a menu, based on the article https://docs.microsoft.com/en-us/azure/virtual-machines/windows/prepare-for-upload-vhd-image
#It's a very simple menu driven power shell script with cmdlets included in the article to facilitate the customizations required to prepare a Windows image to be uploaded to Azure.
#Needs to be executed elevated unde administrator rights powershell prompt. 

function Show-Menu

{
    param (
        [string]$Title = 'Prepare a Windows VHD or VHDX to upload to Azure'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    Write-Host " 
Powershell script with a menu, based on the article https://docs.microsoft.com/en-us/azure/virtual-machines/windows/prepare-for-upload-vhd-image
It's a very simple menu driven power shell script with cmdlets included in the article to facilitate the customizations required to prepare a Windows image to be uploaded to Azure.
Needs to be executed elevated unde administrator rights powershell prompt. 
Batch files are almost always flagged by anti-virus, feel free to review the code if you're unsure." -ForegroundColor green -BackgroundColor black
Write-Host "===================================================================================="

    Write-Host "Press '1' to Remove the WinHTTP proxy."
    Write-Host "Press '2' to Set the disk SAN policy to Onlineall."
    Write-Host "Press '3' to Set Coordinated Universal Time (UTC) time for Windows. Also set the startup type of the Windows time service (w32time) to Automatic."
    Write-Host "Press '4' to Set the power profile to high performance."
    Write-Host "Press '5' to Make sure the environmental variables TEMP and TMP are set to their default values"
    Write-Host "Press '6'to These services are the minimum that must be set up to ensure VM connectivity. To reset the startup settings, run the following commands."
    Write-Host "Press '7' to Remote Desktop Protocol (RDP) is enabled."
    Write-Host "Press '8' to The RDP port is set up correctly. The default port is 3389."
    Write-Host "Press '9' to The listener is listening in every network interface."
    Write-Host "Press '10' to Configure the network-level authentication (NLA) mode for the RDP connections."
    Write-Host "Press '11' to Set the keep-alive value."
    Write-Host "Press '12' to RDP autoreconnect"
    Write-Host "Press '13' to Remove any self-signed certificates tied to the RDP listener."
    Write-Host "Press '14' to Turn on Windows Firewall on the three profiles (domain, standard, and public)"
    Write-Host "Press '15' to Allow WinRM through the three firewall profiles (domain, private, and public), and enable the PowerShell remote service."
    Write-Host "Press '16' to Enable the following firewall rules to allow the RDP traffic."
    Write-Host "Press '17' to Enable the rule for file and printer sharing so the VM can respond to a ping command inside the virtual network."
    Write-Host "Press '18' to Set the Boot Configuration Data (BCD) settings."
    Write-Host "Press '19' to Enable Serial Console Feature."
    Write-Host "Press '20' to Enable the dump log collection."
    Write-Host "Press '21' to Verify that the Windows Management Instrumentation (WMI) repository is consistent."
#    Write-Host "Press '22' to Execute all the above."
    Write-Host "Q: Press 'Q' to quit."
}



do
 {
    Show-Menu
    $selection = Read-Host "Please make a selection"
    switch ($selection)
    {
    '1' {
    'You chose option #1'
    Write-Host "Remove the WinHTTP proxy" -ForegroundColor red -BackgroundColor white
    netsh winhttp reset proxy

 } '2' {
    'You chose option #2'
     Write-Host "Set the disk SAN policy to Onlineall." -ForegroundColor red -BackgroundColor white
     Set-StorageSetting -NewDiskPolicy OnlineAll

 } '3' {
    'You chose option #3'
Write-Host "Set Coordinated Universal Time (UTC) time for Windows. Also set the startup type of the Windows time service (w32time) to Automatic." -ForegroundColor red -BackgroundColor white
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation' -Name "RealTimeIsUniversal" -Value 1 -Type DWord -Force
Set-Service -Name w32time -StartupType Automatic

 } '4' {
    'You chose option #4'
Write-Host "Set the power profile to high performance." -ForegroundColor red -BackgroundColor white
powercfg /setactive SCHEME_MIN

 } '5' {
    'You chose option #5'
Write-Host "Make sure the environmental variables TEMP and TMP are set to their default values" -ForegroundColor red -BackgroundColor white
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name "TEMP" -Value "%SystemRoot%\TEMP" -Type ExpandString -Force
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name "TMP" -Value "%SystemRoot%\TEMP" -Type ExpandString -Force

 } '6' {
    'You chose option #6'
Write-Host "These services are the minimum that must be set up to ensure VM connectivity." -ForegroundColor red -BackgroundColor white
Get-Service -Name bfe | Where-Object { $_.StartType -ne 'Automatic' } | Set-Service -StartupType 'Automatic'
Get-Service -Name dhcp | Where-Object { $_.StartType -ne 'Automatic' } | Set-Service -StartupType 'Automatic'
Get-Service -Name dnscache | Where-Object { $_.StartType -ne 'Automatic' } | Set-Service -StartupType 'Automatic'
Get-Service -Name IKEEXT | Where-Object { $_.StartType -ne 'Automatic' } | Set-Service -StartupType 'Automatic'
Get-Service -Name iphlpsvc | Where-Object { $_.StartType -ne 'Automatic' } | Set-Service -StartupType 'Automatic'
Get-Service -Name netlogon | Where-Object { $_.StartType -ne 'Manual' } | Set-Service -StartupType 'Manual'
Get-Service -Name netman | Where-Object { $_.StartType -ne 'Manual' } | Set-Service -StartupType 'Manual'
Get-Service -Name nsi | Where-Object { $_.StartType -ne 'Automatic' } | Set-Service -StartupType 'Automatic'
Get-Service -Name TermService | Where-Object { $_.StartType -ne 'Manual' } | Set-Service -StartupType 'Manual'
Get-Service -Name MpsSvc | Where-Object { $_.StartType -ne 'Automatic' } | Set-Service -StartupType 'Automatic'
Get-Service -Name RemoteRegistry | Where-Object { $_.StartType -ne 'Automatic' } | Set-Service -StartupType 'Automatic'

 } '7' {
    'You chose option #7'
Write-Host "Remote Desktop Protocol (RDP) is enabled." -ForegroundColor red -BackgroundColor white
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0 -Type DWord -Force
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name "fDenyTSConnections" -Value 0 -Type DWord -Force

 } '8' {
    'You chose option #8'
Write-Host "The RDP port is set up correctly. The default port is 3389." -ForegroundColor red -BackgroundColor white
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -Name "PortNumber" -Value 3389 -Type DWord -Force

 } '9' {
    'You chose option #9'
Write-Host "The listener is listening in every network interface." -ForegroundColor red -BackgroundColor white
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -Name "LanAdapter" -Value 0 -Type DWord -Force

 } '10' {
    'You chose option #10'
Write-Host "Configure the network-level authentication (NLA) mode for the RDP connections." -ForegroundColor red -BackgroundColor white
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1 -Type DWord -Force
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "SecurityLayer" -Value 1 -Type DWord -Force
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "fAllowSecProtocolNegotiation" -Value 1 -Type DWord -Force

 } '11' {
    'You chose option #11'
Write-Host "Set the keep-alive value." -ForegroundColor red -BackgroundColor white
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name "KeepAliveEnable" -Value 1  -Type DWord -Force
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name "KeepAliveInterval" -Value 1  -Type DWord -Force
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -Name "KeepAliveTimeout" -Value 1 -Type DWord -Force

 } '12' {
    'You chose option #12'
Write-Host "RDP autoreconnect" -ForegroundColor red -BackgroundColor white
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name "fDisableAutoReconnect" -Value 0 -Type DWord -Force
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -Name "fInheritReconnectSame" -Value 1 -Type DWord -Force
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -Name "fReconnectSame" -Value 0 -Type DWord -Force

 } '13' {
    'You chose option #13'
Write-Host "Remove any self-signed certificates tied to the RDP listener." -ForegroundColor red -BackgroundColor white
if ((Get-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp').Property -contains "SSLCertificateSHA1Hash")
{
    Remove-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "SSLCertificateSHA1Hash" -Force
}

 } '14' {
    'You chose option #14'
Write-Host "Turn on Windows Firewall on the three profiles (domain, standard, and public)" -ForegroundColor red -BackgroundColor white
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

 } '15' {
    'You chose option #15'
Write-Host "Allow WinRM through the three firewall profiles (domain, private, and public), and enable the PowerShell remote service." -ForegroundColor red -BackgroundColor white
Enable-PSRemoting -Force
Set-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)" -Enabled True

 } '16' {
    'You chose option #16'
Write-Host "Enable the following firewall rules to allow the RDP traffic." -ForegroundColor red -BackgroundColor white
Set-NetFirewallRule -DisplayGroup "Remote Desktop" -Enabled True

 } '17' {
    'You chose option #17'
Write-Host "Enable the rule for file and printer sharing so the VM can respond to a ping command inside the virtual network." -ForegroundColor red -BackgroundColor white
Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -Enabled True

 } '18' {
    'You chose option #18'
Write-Host "Set the Boot Configuration Data (BCD) settings." -ForegroundColor red -BackgroundColor white
bcdedit /set "{bootmgr}" integrityservices enable
bcdedit /set "{default}" device partition=C:
bcdedit /set "{default}" integrityservices enable
bcdedit /set "{default}" recoveryenabled Off
bcdedit /set "{default}" osdevice partition=C:
bcdedit /set "{default}" bootstatuspolicy IgnoreAllFailures

 } '19' {
    'You chose option #19'
Write-Host "Enable Serial Console Feature." -ForegroundColor red -BackgroundColor white
bcdedit /set "{bootmgr}" displaybootmenu yes
bcdedit /set "{bootmgr}" timeout 5
bcdedit /set "{bootmgr}" bootems yes
bcdedit /ems "{current}" ON
bcdedit /emssettings EMSPORT:1 EMSBAUDRATE:115200

 } '20' {
    'You chose option #20'
Write-Host "Enable the dump log collection." -ForegroundColor red -BackgroundColor white
# Set up the guest OS to collect a kernel dump on an OS crash event
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl' -Name CrashDumpEnabled -Type DWord -Force -Value 2
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl' -Name DumpFile -Type ExpandString -Force -Value "%SystemRoot%\MEMORY.DMP"
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl' -Name NMICrashDump -Type DWord -Force -Value 1

# Set up the guest OS to collect user mode dumps on a service crash event
$key = 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps'
if ((Test-Path -Path $key) -eq $false) {(New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting' -Name LocalDumps)}
New-ItemProperty -Path $key -Name DumpFolder -Type ExpandString -Force -Value "c:\CrashDumps"
New-ItemProperty -Path $key -Name CrashCount -Type DWord -Force -Value 10
New-ItemProperty -Path $key -Name DumpType -Type DWord -Force -Value 2
Set-Service -Name WerSvc -StartupType Manual

 } '21' {
    'You chose option #21'
Write-Host "Verify that the Windows Management Instrumentation (WMI) repository is consistent." -ForegroundColor red -BackgroundColor white
winmgmt /verifyrepository

} '22' {
    'You chose option #21'
    Write-Host "Execute all." -ForegroundColor red -BackgroundColor white   
    #Need help to make a function to recursively execute all above scripts.    
    
    }
    }
    pause
 }
 until ($selection -eq 'q')
 
Write-Host "For more information and detailed instructions please visit: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/prepare-for-upload-vhd-image"  -ForegroundColor green -BackgroundColor black


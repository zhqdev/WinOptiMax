Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:SystemRoot\Logs\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:SystemRoot\System32\LogFiles\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:ProgramData\Microsoft\Diagnosis\ETLLogs\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:ProgramData\Microsoft\Windows Defender\Scans\History\*" -Recurse -Force -ErrorAction SilentlyContinue
try { Clear-RecycleBin -Force -ErrorAction SilentlyContinue } catch {}
ipconfig /flushdns | Out-Null
netsh winsock reset | Out-Null
netsh int ip reset | Out-Null
netsh advfirewall reset | Out-Null
$services = @(
    "SysMain", "DiagTrack", "WSearch", "Fax", "XblGameSave",
    "WMPNetworkSvc", "RetailDemo", "Spooler", "MapsBroker",
    "PrintNotify", "PcaSvc", "PcdSvc", "WBioSrvc", "WMPNetworkSvc",
    "W32Time", "wuauserv", "BITS", "CDPSvc", "lfsvc", "wscsvc"
)
foreach ($svc in $services) {
    if (Get-Service -Name $svc -ErrorAction SilentlyContinue) {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
    }
}
powercfg -setactive SCHEME_MIN | Out-Null
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=4096,MaximumSize=8192 | Out-Null
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable | Out-Null
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable | Out-Null
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable | Out-Null
schtasks /Change /TN "Microsoft\Windows\DiskCleanup\SilentCleanup" /Enable | Out-Null
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "0"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value "0"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00))
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f | Out-Null
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f | Out-Null
reg add "HKCU\Control Panel\Desktop" /v ForegroundFlashCount /t REG_DWORD /d 1 /f | Out-Null

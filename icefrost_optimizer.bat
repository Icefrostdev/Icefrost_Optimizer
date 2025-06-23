@echo off
@echo off
TITLE Icefrost Optimizer "Frost"
mode con cols=80 lines=44
chcp 65001 >nul
color 0F
cls

CALL :LOGO

:: ==========================
:: SAFETY WARNING PROMPT
:: ==========================
:SAFETY_MENU
cls
color 0C
echo.
echo [91m[ WARNING ] Icefrost Optimizer [0m
echo ------------------------------------------------------------
echo This optimizer makes critical system modifications.
echo.
echo It is strongly recommended that you:
echo   - Create a System Restore Point
echo   - Backup the Registry
echo.
echo Proceed only if you understand the risks.
echo ------------------------------------------------------------
echo.
echo   [ 1 ] Run Restore + Backup and Continue
echo   [ 2 ] Create System Restore Point only
echo   [ 3 ] Backup Registry only
echo   [ 0 ] Exit
echo.

set /p choice="Select an option: "

if "%choice%"=="1" (
	echo Creating system restore point...
	powershell -Command "Checkpoint-Computer -Description 'Icefrost Optimizer Restore Point' -RestorePointType 'Modify_Settings'"
    echo Backing up full registry...

:: Extract clean date format: MM-DD-YYYY
	for /f "tokens=2 delims= " %%a in ("%DATE%") do set fulldate=%%a
	for /f "tokens=1-3 delims=/" %%a in ("%fulldate%") do (
    set "month=%%a"
    set "day=%%b"
    set "year=%%c"
	)
	set "backupDate=%month%-%day%-%year%"

:: Set target directory
	set "backupDir=C:\Backup Registry"
	mkdir "%backupDir%" >nul 2>&1

:: Export each full root hive
	reg export HKEY_CLASSES_ROOT         "%backupDir%\HKEY_CLASSES_ROOT_%backupDate%.reg" /y >nul 2>&1
	reg export HKEY_CURRENT_CONFIG       "%backupDir%\HKEY_CURRENT_CONFIG_%backupDate%.reg" /y >nul 2>&1
	reg export HKEY_CURRENT_USER         "%backupDir%\HKEY_CURRENT_USER_%backupDate%.reg" /y >nul 2>&1
	reg export HKEY_LOCAL_MACHINE        "%backupDir%\HKEY_LOCAL_MACHINE_%backupDate%.reg" /y >nul 2>&1

	echo Registry backup completed.
	echo Backups saved to: "%backupDir%"
    color 0F
    cls
    goto MENU
	
	) else if "%choice%"=="2" (
    goto CreateRestorePoint

	) else if "%choice%"=="3" (
    goto BackupRegistry
	
	) else if "%choice%"=="0" (
    echo Exiting...
    timeout /t 2 >nul
    exit /b
	) else (
    echo Invalid option.
    timeout /t 1 >nul
    goto SAFETY_MENU_

color 0F
cls

:: Proceed to Menu
:MENU
CALL :LOGO


echo.
echo	    [38;5;196m[ Main Tweaks ]
echo.
echo   [90m^>  [90m1.  Mouse Fix Tweaks
echo   [90m^>  [90m2.  Keyboard and Mouse Queue Size
echo   [90m^>  [90m3.  Disable HPET
echo   [90m^>  [90m4.  Disable Prefetch and Superfetch
echo   [90m^>  [90m5.  Disable Sleep and Hibernate
echo   [90m^>  [90m6.  Clear Temporary Files
echo   [90m^>  [90m7.  Disable Game DVR
echo   [90m^>  [90m8.  Disable CPU Idle
echo   [90m^>  [90m9.  UI Responsiveness Tweaks
echo   [90m^>  [90m10. Win32PrioritySeparation
echo.
echo	    [38;5;208m[ Additional Tweaks ]
echo.
echo   [90m^>  [90m11. Download Resources (Tools)
echo   [90m^>  [90m12. Optimize Nvidia GPU
echo   [90m^>  [90m13. Setup Timer Resolution
echo   [90m^>  [90m14. Optimize Disk
echo   [90m^>  [90m15. Debloat System
echo   [90m^>  [90m16. Power Gating
echo   [90m^>  [90m17. FullScreen_Optimizaitons
echo   [90m^>  [90m18. Apply ALL Additional Tweaks
echo.
echo	    [38;5;220m[ Important ]
echo.
echo   [90m^>  [90mA. Apply ALL Tweaks
echo   [90m^>  [90mR. Revert Tweaks Menu
echo   [90m^>  [90mQ. Revert Additional Tweaks
echo   [90m^>  [90mS. Create System Restore Point (important)
echo   [90m^>  [90mB. Backup Registry Settings (important)
echo   [90m^>  [90mE. Exit
echo.

SET /P choice= [90m  [Choose an option 1-17 or A-R-Q-S-B-E[90m]: [90m
echo.

REM Main Tweaks
IF "%choice%"=="1" GOTO MouseTweaks
IF "%choice%"=="2" GOTO QueueTweaks
IF "%choice%"=="3" GOTO DisableHPET
IF "%choice%"=="4" GOTO DisablePrefetch
IF "%choice%"=="5" GOTO DisableSleep
IF "%choice%"=="6" GOTO ClearTemp
IF "%choice%"=="7" GOTO DisableGameDVR
IF "%choice%"=="8" GOTO DisableIdle
IF "%choice%"=="9" GOTO UIResponsivenessTweaks
IF "%choice%"=="10" GOTO PriorityControl

REM Additional Tweaks
IF "%choice%"=="11" GOTO DownloadResources
IF "%choice%"=="12" GOTO OptimizeNvidiaGPU
IF "%choice%"=="13" GOTO SetupTimerResolution
IF "%choice%"=="14" GOTO OptimizeDisk
IF "%choice%"=="15" GOTO DebloatSystem
IF "%choice%"=="16" GOTO PowerGating
IF "%choice%"=="17" GOTO FullScreen_Optimizaitons
IF "%choice%"=="18" GOTO windowssettings


REM Important Options
IF /I "%choice%"=="A" GOTO ApplyAll
IF /I "%choice%"=="R" GOTO RevertMenu
IF /I "%choice%"=="Q" GOTO RevertAdditionalTweaks
IF /I "%choice%"=="S" GOTO CreateRestorePoint
IF /I "%choice%"=="B" GOTO BackupRegistry
IF /I "%choice%"=="E" GOTO Exit

echo [91mInvalid option. Please try again.
pause
GOTO MENU

::----------------------------
:: Tweaks Subroutines (unchanged)...
::----------------------------

:MouseTweaks
echo Applying Mouse Fix Tweaks...
reg add "HKCU\Control Panel\Mouse" /v MouseSensitivity /t REG_SZ /d 10 /f
reg add "HKCU\Control Panel\Mouse" /v SmoothMouseXCurve /t REG_BINARY /d 0000000000000000C00CCC0000000000000099800000000000002646400000000000000003333000000000000 /f
reg add "HKCU\Control Panel\Mouse" /v SmoothMouseYCurve /t REG_BINARY /d 0000000000000000000038000000000000007000000000000000A800000000000000E000000000000000 /f
reg add "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f
reg add "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f
reg add "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f
echo Done.
pause
GOTO MENU

:QueueTweaks
echo Setting Keyboard and Mouse Queue Size to 30...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize /t REG_DWORD /d 30 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v KeyboardDataQueueSize /t REG_DWORD /d 30 /f
echo Done.
pause
GOTO MENU

:DisableHPET
echo Disabling HPET...
bcdedit /deletevalue useplatformclock >nul 2>&1
echo Done.
pause
GOTO MENU

:DisablePrefetch
echo Disabling Prefetch and Superfetch...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f
echo Done.
pause
GOTO MENU

:DisableSleep
echo Disabling Sleep and Hibernate...
powercfg -h off
powercfg -change -standby-timeout-ac 0
powercfg -change -monitor-timeout-ac 0
powercfg -change -disk-timeout-ac 0
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR IdleDisable 1
powercfg.exe /SETACTIVE SCHEME_CURRENT
echo Done.
pause
GOTO MENU

:ClearTemp
echo Clearing Temporary Files...
del /s /f /q %temp%\* >nul 2>&1
del /s /f /q C:\Windows\Temp\* >nul 2>&1
echo Done.
pause
GOTO MENU

:DisableGameDVR
echo Disabling Game DVR...
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f
echo Done.
pause
GOTO MENU

:DisableIdle
echo Disabling CPU Idle...
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR IdleDisable 1
powercfg.exe /SETACTIVE SCHEME_CURRENT
echo Done.
pause
GOTO MENU

:UIResponsivenessTweaks
echo Setting UI Responsiveness Tweaks (Menu Show Delay + Mouse Hover Time)...
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Mouse" /v MouseHoverTime /t REG_SZ /d 10 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v SearchOrderConfig /t REG_DWORD /d 0 /f
echo Done.
pause
GOTO MENU

:PriorityControl
echo Setting PriorityControl Win32PrioritySeparation...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 0x00000026 /f
echo Done.
pause
GOTO MENU

:: Additional Tweaks (same as before)...

:DownloadResources
echo Downloading Resources...
curl -g -k -L -# -o "%temp%\Stix Free.zip" "https://www.dropbox.com/scl/fi/qdgw7wcn7oesd3rbfu883/Stix-Free.zip?rlkey=6ed88ulyityakfpyv7f0que9d&st=6eeunx33&dl=1" >nul 2>&1
powershell -NoProfile Expand-Archive '%temp%\Stix Free.zip' -DestinationPath 'C:\' >nul 2>&1
echo Successfully Downloaded Resources
timeout 3
echo Done.
pause
GOTO MENU

:OptimizeNvidiaGPU
echo - Optimizing Your Nvidia GPU...
reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup" /v "SendTelemetryData" /t REG_DWORD /d "0" /f >nul 2>&1
schtasks /change /disable /tn "NvTmRep_CrashReport2_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>&1
schtasks /change /disable /tn "NvTmRep_CrashReport3_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>&1
schtasks /change /disable /tn "NvTmRep_CrashReport4_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "DisablePreemption" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "DisableCudaContextPreemption" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "EnableCEPreemption" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "DisablePreemptionOnS3S4" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "ComputePreemption" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "EnableMidGfxPreemption" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "EnableMidGfxPreemptionVGPU" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "EnableMidBufferPreemptionForHighTdrTimeout" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "EnableMidBufferPreemption" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "EnableAsyncMidBufferPreemption" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm\Global\NVTweak" /v "DisplayPowerSaving" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "DisplayPowerSaving" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001" /v "RMPowerFeature" /t REG_DWORD /d "4" /f >nul 2>&1
"C:\Stix Free\nvidiaProfileInspector.exe" -import "C:\Stix Free\Stix Free NIP.nip"
echo - Successfully Optimized Your Nvidia GPU...
timeout 2 >nul
echo Done.
pause
GOTO MENU

:SetupTimerResolution
echo Setting up Timer Resolution...

:: Registry tweak
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d 1 /f >nul 2>&1

:: Setup paths
set "exeUrl=https://www.dropbox.com/scl/fi/uv869o0oo544t1gbgle55/SetTimerResolution.exe?rlkey=edatyvmqbgyh35l45rtiz8m10&st=o72mxwrm&dl=1"
set "exeFilePath=C:\SetTimerResolution.exe"
set "startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "shortcutPath=%startupFolder%\SetTimerResolution.lnk"

:: Download file
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%exeUrl%', '%exeFilePath%')"

:: Create shortcut via VBScript
echo Set oShell = CreateObject("WScript.Shell") > "%startupFolder%\CreateShortcut.vbs"
echo Set oLink = oShell.CreateShortcut("%shortcutPath%") >> "%startupFolder%\CreateShortcut.vbs"
echo oLink.TargetPath = "%exeFilePath%" >> "%startupFolder%\CreateShortcut.vbs"
echo oLink.Arguments = "--resolution 5040 --no-console" >> "%startupFolder%\CreateShortcut.vbs"
echo oLink.WorkingDirectory = "C:\" >> "%startupFolder%\CreateShortcut.vbs"
echo oLink.Save >> "%startupFolder%\CreateShortcut.vbs"

:: Run the script to create shortcut
cscript //nologo "%startupFolder%\CreateShortcut.vbs"
del "%startupFolder%\CreateShortcut.vbs"

:: (Optional) Run the EXE now
start "" "%exeFilePath%" --resolution 5040 --no-console

echo - Successfully Setup Timer Resolution...
echo Done.

pause
GOTO MENU

:OptimizeDisk
echo Optimizing Disk...
fsutil behavior set disableEncryption 1 >nul 2>&1
fsutil 8dot3name set 1 >nul 2>&1
fsutil behavior set memoryusage 2 >nul 2>&1
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil resource setautoreset true C:\ >nul 2>&1
fsutil resource setconsistent C:\ >nul 2>&1
fsutil resource setlog shrink 10 C:\ >nul 2>&1
echo - Successfully Optimized Your Disk...
echo Done.
pause
GOTO MENU

:DebloatSystem
echo Debloating System...
echo - Debloating Your System
set "tempFolder=%LOCALAPPDATA%\Temp"
if exist "%tempFolder%" (
    del /q /s "%tempFolder%\*.*"
    echo Contents of Temp folder have been deleted.
) else (
    echo Temp folder not found.
)

echo Cleaning C:\Windows\Temp folder...
del /q /s "C:\Windows\Temp\*.*"
echo Contents of C:\Windows\Temp folder have been deleted.

echo Cleaning C:\Windows\Prefetch folder...
del /q /s "C:\Windows\Prefetch\*.*"
echo Contents of C:\Windows\Prefetch folder have been deleted.

echo Cleaning Windows Error Reporting files...
del /q /s "%LOCALAPPDATA%\Microsoft\Windows\WER\ReportQueue\*"
echo Windows Error Reporting files have been deleted.

echo Cleaning Windows temporary files...
del /q /s "%windir%\Temp\*"
echo Windows temporary files have been deleted.

echo Cleaning Windows logs...
wevtutil cl Application
wevtutil cl System
wevtutil cl Security
echo Windows logs have been cleared.

powershell.exe -command "Get-WindowsPackage -Online | Where PackageName -like '*Hello-Face*' | Remove-WindowsPackage -Online -NoRestart"
powershell.exe -command "Get-WindowsPackage -Online | Where PackageName -like '*QuickAssist*' | Remove-WindowsPackage -Online -NoRestart"
:: ... (repeat your appxpackage removals as you want)
:: You can add all your appx removals here as per your previous commands

:: OneDrive uninstall commands (adjust usernames if needed)
C:\Windows\SysWOW64\OneDriveSetup.exe /uninstall >nul 2>&1
sc config RemoteRegistry start= disabled >nul 2>&1
sc config RemoteAccess start= disabled >nul 2>&1
sc config WinRM start= disabled >nul 2>&1
sc config RmSvc start= disabled >nul 2>&1
sc config PrintNotify start= disabled >nul 2>&1
sc config Spooler start= disabled >nul 2>&1
echo Debloat completed.
pause
GOTO MENU

:PowerGating
echo Applying Power Gating Tweaks...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Processor" /v "FeatureSettingsOverride" /t REG_DWORD /d 0x400 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Processor" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d 0x400 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Processor" /v "PowerStateTimeout" /t REG_DWORD /d 0x7fffffff /f >nul 2>&1
echo Power Gating Tweaks Applied.
pause
GOTO MENU

:FullScreen_Optimizaitons
echo Applying Fullscreen Optimization Tweaks...
timeout /t 1 >nul

:: Disable GameDVR and Fullscreen Optimizations
reg add "HKCU\System\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatibility" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f >nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 1 /f >nul

echo.
echo Fullscreen Optimization Tweaks Applied Successfully!
timeout /t 1 >nul
pause
GOTO MENU

:: ==== WINDOWS SETTINGS TWEAKS ====
:windowssettings
echo - Optimizing Boot Config
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformtick yes >nul 2>&1
timeout 2 >nul 2>&1

echo - Disabling ThreadDPC
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ThreadDpcEnable" /t REG_DWORD /d "0" /f >nul 2>&1
timeout 2 >nul 2>&1

echo - Disabling Fault Tolerant Heap
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\FTH" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
timeout 2 >nul 2>&1

echo - Setting CSRSS IO and CPU Priority
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "3" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1
timeout 2 >nul 2>&1

echo - Setting System Responsiveness
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f >nul 2>&1
timeout 2 >nul 2>&1

echo - Disabling IoLatencyCap
FOR /F "eol=E" %%a in ('REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "IoLatencyCap"^| FINDSTR /V "IoLatencyCap"') DO (
	REG ADD "%%a" /F /V "IoLatencyCap" /T REG_DWORD /d 0 >nul 2>&1
)
timeout 2 >nul 2>&1

echo - Enabling Game Mode
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
timeout 2 >nul 2>&1

echo - Disabling StorPort Idle
for /f "tokens=*" %%s in ('reg query "HKLM\System\CurrentControlSet\Enum" /S /F "StorPort" ^| findstr /e "StorPort"') do reg add "%%s" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f >nul 2>&1
timeout 2 >nul 2>&1

echo - Enabling HAGS
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1
timeout 2 >nul 2>&1

echo - Disabling Windows Tracking
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\Maps" /v "AutoUpdateEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableWindowsLocationProvider" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
timeout 2 >nul 2>&1

echo - Optimizing System Profile
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SchedulerPeriod" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "MaxThreadsTotal" /t REG_DWORD /d 128 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "MaxThreadsPerProcess" /t REG_DWORD /d 10 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "IdleDetectionCycles" /t REG_DWORD /d 0 /f >nul 2>&1
timeout 2 >nul 2>&1

echo - Disabling VBS
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 0 /f >nul 2>&1
timeout 2 >nul 2>&1

echo - Setting PriorityControl Win32PrioritySeparation
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 0x00000026 /f
timeout 2 >nul 2>&1

echo - Disabling Power Throttling & Hibernation
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d 1 /f >nul 2>&1
powercfg -h off
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberBootEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
timeout 2 >nul 2>&1

echo - Disabling Storage Sense
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "01" /t REG_DWORD /d 0 /f >nul 2>&1
timeout 2 >nul 2>&1

echo - Disabling Sleep Study
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepstudyAccountingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDeviceAccountingLevel" /t REG_DWORD /d "0" /f >nul 2>&1
timeout 2 >nul 2>&1

echo - Disabling Energy Logging
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f >nul 2>&1
timeout 2 >nul 2>&1

echo - Disabling MMCSS
reg add "HKLM\SYSTEM\CurrentControlSet\Services\MMCSS" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
timeout 2 >nul 2>&1


echo - Disabling DMA Remapping
for %%a in (DmaRemappingCompatible) do (
  for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "%%a" ^| findstr "HKEY"') do (
    Reg.exe add "%%b" /v "%%a" /t REG_DWORD /d "0" /f >nul 2>&1
  )
)
timeout 2 >nul 2>&1

echo - Applying Kernel Tweaks
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v DpcWatchdogProfileOffset /t REG_DWORD /d 2710 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v MaxDynamicTickDuration /t REG_DWORD /d 10 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v MinimumDpcRate /t REG_DWORD /d 1 /f
timeout 2 >nul 2>&1

echo - Disabling Windows Updates
"C:\Stix Free\Wub.exe"
timeout 2 >nul 2>&1

echo - Successfully Ran Windows Tweaks...
timeout 1 >nul 2>&1
GOTO MENU

:ApplyAll
echo Applying All Tweaks...
CALL :MouseTweaks
CALL :QueueTweaks
CALL :DisableHPET
CALL :DisablePrefetch
CALL :DisableSleep
CALL :ClearTemp
CALL :DisableGameDVR
CALL :DisableIdle
CALL :UIResponsivenessTweaks
CALL :PriorityControl
CALL :DownloadResources
CALL :OptimizeNvidiaGPU
CALL :SetupTimerResolution
CALL :OptimizeDisk
CALL :DebloatSystem
CALL :PowerGating
echo All tweaks applied.
pause
GOTO MENU

:RevertMenu
cls
CALL :LOGO
echo.
echo [ Revert Tweaks Menu ]
echo.
echo 1. Revert Mouse Fix Tweaks
echo 2. Revert Keyboard and Mouse Queue Size
echo 3. Revert Disable HPET
echo 4. Revert Disable Prefetch and Superfetch
echo 5. Revert Disable Sleep and Hibernate
echo 6. Revert Clear Temporary Files
echo 7. Revert Disable Game DVR
echo 8. Revert Disable CPU Idle
echo 9. Revert UI Responsiveness Tweaks
echo 10. Revert PriorityControl Win32PrioritySeparation
echo R. Return to Main Menu
echo.
SET /P revertChoice= Choose revert option (1-10 or R): 
IF "%revertChoice%"=="1" GOTO RevertMouseTweaks
IF "%revertChoice%"=="2" GOTO RevertQueueTweaks
IF "%revertChoice%"=="3" GOTO RevertHPET
IF "%revertChoice%"=="4" GOTO RevertPrefetch
IF "%revertChoice%"=="5" GOTO RevertSleep
IF "%revertChoice%"=="6" GOTO RevertClearTemp
IF "%revertChoice%"=="7" GOTO RevertGameDVR
IF "%revertChoice%"=="8" GOTO RevertIdle
IF "%revertChoice%"=="9" GOTO RevertUIResponsiveness
IF "%revertChoice%"=="10" GOTO RevertPriorityControl
IF /I "%revertChoice%"=="R" GOTO MENU
echo Invalid option.
pause
GOTO RevertMenu

:RevertMouseTweaks
echo Reverting Mouse Fix Tweaks...
reg delete "HKCU\Control Panel\Mouse" /v MouseSensitivity /f >nul 2>&1
reg delete "HKCU\Control Panel\Mouse" /v SmoothMouseXCurve /f >nul 2>&1
reg delete "HKCU\Control Panel\Mouse" /v SmoothMouseYCurve /f >nul 2>&1
reg delete "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v MouseSpeed /f >nul 2>&1
reg delete "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v MouseThreshold1 /f >nul 2>&1
reg delete "HKEY_USERS\.DEFAULT\Control Panel\Mouse" /v MouseThreshold2 /f >nul 2>&1
echo Done.
pause
GOTO RevertMenu

:RevertQueueTweaks
echo Reverting Keyboard and Mouse Queue Size...
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v KeyboardDataQueueSize /f >nul 2>&1
echo Done.
pause
GOTO RevertMenu

:RevertHPET
echo Reverting Disable HPET...
bcdedit /set useplatformclock true >nul 2>&1
echo Done.
pause
GOTO RevertMenu

:RevertPrefetch
echo Reverting Disable Prefetch and Superfetch...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 3 /f >nul 2>&1
echo Done.
pause
GOTO RevertMenu

:RevertSleep
echo Reverting Disable Sleep and Hibernate...
powercfg -h on
powercfg -change -standby-timeout-ac 15
powercfg -change -monitor-timeout-ac 10
powercfg -change -disk-timeout-ac 10
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR IdleDisable 0
powercfg.exe /SETACTIVE SCHEME_CURRENT
echo Done.
pause
GOTO RevertMenu

:RevertClearTemp
echo Clearing Temporary Files is non-revertible.
pause
GOTO RevertMenu

:RevertGameDVR
echo Reverting Disable Game DVR...
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 0 /f >nul 2>&1
echo Done.
pause
GOTO RevertMenu

:RevertIdle
echo Reverting Disable CPU Idle...
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR IdleDisable 0
powercfg.exe /SETACTIVE SCHEME_CURRENT
echo Done.
pause
GOTO RevertMenu

:RevertUIResponsiveness
echo Reverting UI Responsiveness Tweaks...
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 400 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseHoverTime /t REG_SZ /d 400 /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v SearchOrderConfig /f >nul 2>&1
echo Done.
pause
GOTO RevertMenu

:RevertPriorityControl
echo Reverting PriorityControl Win32PrioritySeparation...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 0x00000026 /f >nul 2>&1
echo Done.
pause
GOTO RevertMenu

:RevertAdditionalTweaks
cls
CALL :LOGO
echo.
===========================================================
echo      [ Revert Additional Tweaks (IMPORTANT) ]
echo.

echo Reverting Additional Tweaks...

:: Revert Download Resources - delete downloaded files and folder
if exist "C:\Stix Free\" rd /s /q "C:\Stix Free\"
if exist "%temp%\Stix Free.zip" del /f /q "%temp%\Stix Free.zip"

:: Revert Optimize Nvidia GPU
reg delete "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup" /v "SendTelemetryData" /f >nul 2>&1
schtasks /change /enable /tn "NvTmRep_CrashReport2_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>&1
schtasks /change /enable /tn "NvTmRep_CrashReport3_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>&1
schtasks /change /enable /tn "NvTmRep_CrashReport4_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>&1

reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "DisablePreemption" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "DisableCudaContextPreemption" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "EnableCEPreemption" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "DisablePreemptionOnS3S4" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "ComputePreemption" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "EnableMidGfxPreemption" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "EnableMidGfxPreemptionVGPU" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "EnableMidBufferPreemptionForHighTdrTimeout" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "EnableMidBufferPreemption" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm" /v "EnableAsyncMidBufferPreemption" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\nvlddmkm\Global\NVTweak" /v "DisplayPowerSaving" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global\NVTweak" /v "DisplayPowerSaving" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001" /v "RMPowerFeature" /f >nul 2>&1

:: Revert Setup Timer Resolution
del "C:\SetTimerResolution.exe" >nul 2>&1
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\SetTimerResolution - Shortcut.lnk" >nul 2>&1

:: Revert Optimize Disk
fsutil behavior set disableEncryption 0 >nul 2>&1
fsutil 8dot3name set 2 >nul 2>&1
fsutil behavior set memoryusage 1 >nul 2>&1
fsutil behavior set disablelastaccess 0 >nul 2>&1
fsutil resource setautoreset false C:\ >nul 2>&1

:: Revert Debloat System - Re-enable services & tasks
sc config RemoteRegistry start= auto >nul 2>&1
sc config RemoteAccess start= auto >nul 2>&1
sc config WinRM start= auto >nul 2>&1
sc config RmSvc start= auto >nul 2>&1
sc config PrintNotify start= auto >nul 2>&1
sc config Spooler start= auto >nul 2>&1

:: ==== REVERT WINDOWS SETTINGS TWEAKS ====
echo - Reverting Boot Config
bcdedit /set useplatformclock true >nul 2>&1
bcdedit /deletevalue disabledynamictick >nul 2>&1
bcdedit /deletevalue useplatformtick >nul 2>&1
timeout 2 >nul

echo - Re-enabling ThreadDPC
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ThreadDpcEnable" /f >nul 2>&1
timeout 2 >nul

echo - Enabling Fault Tolerant Heap
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\FTH" /v Enabled /t REG_DWORD /d 1 /f >nul 2>&1
timeout 2 >nul

echo - Resetting CSRSS IO and CPU Priority
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe" /f >nul 2>&1
timeout 2 >nul

echo - Restoring System Responsiveness
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /f >nul 2>&1
timeout 2 >nul

echo - Restoring IoLatencyCap (manual review may be needed)
REM Cannot reliably restore all previous values; consider backup first.
timeout 2 >nul

echo - Disabling Game Mode
reg delete "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /f >nul 2>&1
timeout 2 >nul

echo - Re-enabling StorPort Idle
REM You may need to manually restore exact values if needed
timeout 2 >nul

echo - Disabling HAGS (default is 1)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 1 /f >nul 2>&1
timeout 2 >nul

echo - Re-enabling Windows Tracking
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /f >nul 2>&1
reg delete "HKLM\SYSTEM\Maps" /v "AutoUpdateEnabled" /f >nul 2>&1
reg delete "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /f >nul 2>&1
reg delete "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableWindowsLocationProvider" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" /v "Enabled" /f >nul 2>&1
timeout 2 >nul

echo - Resetting System Profile Values
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SchedulerPeriod" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "MaxThreadsTotal" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "MaxThreadsPerProcess" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "IdleDetectionCycles" /f >nul 2>&1
timeout 2 >nul

echo - Enabling VBS
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 1 /f >nul 2>&1
timeout 2 >nul

echo - Re-enabling Power Throttling & Hibernation
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /f >nul 2>&1
powercfg -h on
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberBootEnabled" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /f >nul 2>&1
timeout 2 >nul

echo - Enabling Storage Sense
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "01" /f >nul 2>&1
timeout 2 >nul

echo - Enabling Sleep Study
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepstudyAccountingEnabled" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDeviceAccountingLevel" /f >nul 2>&1
timeout 2 >nul

echo - Enabling Energy Logging
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /f /va >nul 2>&1
timeout 2 >nul

echo - Enabling MMCSS
reg add "HKLM\SYSTEM\CurrentControlSet\Services\MMCSS" /v "Start" /t REG_DWORD /d 2 /f >nul 2>&1
timeout 2 >nul

echo - Re-enabling DMA Remapping
REM Manual restoration may be required
timeout 2 >nul

echo - Reverting Kernel Tweaks
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v DpcWatchdogProfileOffset /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v MaxDynamicTickDuration /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v MinimumDpcRate /f >nul 2>&1
timeout 2 >nul

echo - Skipping Wub.exe (manual toggle recommended)
timeout 2 >nul

echo Revert Additional Tweaks Completed.
pause
GOTO MENU


==========================================================


:CreateRestorePoint
echo Creating system restore point...
powershell -Command "Checkpoint-Computer -Description 'Icefrost Optimizer Restore Point' -RestorePointType 'Modify_Settings'"
echo Done.
pause
GOTO MENU

:BackupRegistry
echo Backing up full registry hives...

:: Extract clean date format: MM-DD-YYYY
for /f "tokens=2 delims= " %%a in ("%DATE%") do set fulldate=%%a
for /f "tokens=1-3 delims=/" %%a in ("%fulldate%") do (
    set "month=%%a"
    set "day=%%b"
    set "year=%%c"
)
set "backupDate=%month%-%day%-%year%"

:: Set target directory
set "backupDir=C:\Backup Registry"
mkdir "%backupDir%" >nul 2>&1

:: Export each full root hive
reg export HKEY_CLASSES_ROOT         "%backupDir%\HKEY_CLASSES_ROOT_%backupDate%.reg" /y >nul 2>&1
reg export HKEY_CURRENT_CONFIG       "%backupDir%\HKEY_CURRENT_CONFIG_%backupDate%.reg" /y >nul 2>&1
reg export HKEY_CURRENT_USER         "%backupDir%\HKEY_CURRENT_USER_%backupDate%.reg" /y >nul 2>&1
reg export HKEY_LOCAL_MACHINE        "%backupDir%\HKEY_LOCAL_MACHINE_%backupDate%.reg" /y >nul 2>&1

echo Registry backup completed.
echo Backups saved to: "%backupDir%"
pause
GOTO MENU


=========================================================================
:Exit
echo Exiting...
exit /b

:LOGO
echo.
echo.
echo		[38;5;196m███████╗██████╗  ██████╗ ███████╗████████╗[0m
echo		[38;5;202m██╔════╝██╔══██╗██╔═══██╗██╔════╝╚══██╔══╝[0m
echo		[38;5;208m█████╗  ██████╔╝██║   ██║███████╗   ██║[0m   
echo		[38;5;214m██╔══╝  ██╔══██╗██║   ██║╚════██║   ██║[0m   
echo		[38;5;220m██║     ██║  ██║╚██████╔╝███████║   ██║[0m   
echo		[38;5;226m╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝[0m  




=========================================================================
                                          

                                                                                                                                  

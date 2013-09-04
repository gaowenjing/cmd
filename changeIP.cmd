@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------


set adapter=lan
set newDNS=202.96.128.68
set defaultSubnet=255.255.255.0

:begin
set /a ran=%RANDOM%%%252+2

echo Please choose (current adapter:%adapter%):
echo [1..9]  switch to conf[1..9]	d  get IP from DHCP
echo m  manually set IP			y  apply new configuration
echo q  quit				h  help
echo b  backup current conf		c  show current ipconf
echo p  ping gateway			r  show current ipv4 route
echo x  disable "%adapter%"		o  enable "%adapter%"
echo z  switch to cmd			n  show new conf

:showconf
if defined newIP (
	echo curIF=%adapter%
	echo newIP=%newIP%
	echo newSubnet=%newSubnet%
	echo newGW=%newGW%
	echo newDNS=%newDNS%
)

:selection
choice /c 123456789dmyqhbcrxopszn
if %ERRORLEVEL% == 1 call :conf1
if %ERRORLEVEL% == 2 call :conf2
if %ERRORLEVEL% == 3 call :conf3
if %ERRORLEVEL% == 4 call :conf4
if %ERRORLEVEL% == 5 call :conf5
if %ERRORLEVEL% == 6 call :conf6
if %ERRORLEVEL% == 7 call :conf7
if %ERRORLEVEL% == 8 call :conf8
if %ERRORLEVEL% == 9 call :conf9
if %ERRORLEVEL% == 10 call :dhcp
if %ERRORLEVEL% == 11 goto manually
if %ERRORLEVEL% == 12 goto :applyconf
if %ERRORLEVEL% == 13 goto end
if %ERRORLEVEL% == 14 goto begin
if %ERRORLEVEL% == 15 call :backup
if %ERRORLEVEL% == 16 call :showip
if %ERRORLEVEL% == 17 call :showroute
if %ERRORLEVEL% == 18 call :disablelan
if %ERRORLEVEL% == 19 call :enablelan
if %ERRORLEVEL% == 20 call :pinggw
if %ERRORLEVEL% == 21 call :changeadapter
if %ERRORLEVEL% == 22 call :switchtocmd
if %ERRORLEVEL% == 23 goto :showconf

goto selection

rem *******************************
rem manually set IP
rem *******************************
:manually
:setIP
if not defined newIP (
	echo Please input the new IP address: 
) else (
	echo Please input the new IP address: [default is %newIP%]
)
set /p newIP=">"
if not defined newIP goto selection

call :checkip %newIP%
if %ERRORLEVEL% == 1 (
	echo ERROR: Wrong IP format...
	goto selection
)

rem *******************************
rem manually set subnet
rem *******************************
echo please input the new subnet address (default is 255.255.255.0)
set /p newSubnet=">"
if not defined newSubnet set newSubnet=%defaultSubnet%

rem *******************************
rem manually set gateway
rem *******************************
echo please input the new gateway address
set /p newGW=">"
rem if not defined newGW goto begin

:applyconf
netsh int ipv4 set add "%adapter%" static %newIP% %newSubnet% %newGW%
if %ERRORLEVEL% NEQ 0 (
	goto selection
) else (
	echo INFO: New conf has successfully apply.
)

rem *******************************
rem manually set DNS
rem *******************************
:setDNS
echo please input the new DNS address (default is %newDNS%)
set /p newDNS=">"
rem if not defined newDNS goto selection
rem if %newDNS% == default set newDNS=%defaultDNS%

netsh int ipv4 set dns "%adapter%" static %newDNS% primary
rem set backup DNS below:
rem netsh int ipv4 add dns "%adapter%" static 202.96.134.133

goto selection

rem *******************************
rem FUNCTIONS
rem *******************************

:showip
netsh int ip show add "%adapter%"
netsh int ip show dns "%adapter%"
goto :EOF

:disablelan
netsh int set int "%adapter%" disable 
goto :EOF

:enablelan
netsh int set int "%adapter%" enable
goto :EOF

:pinggw
start ping -t %newGW%
goto :EOF

:changeadapter
if %adapter% == lan (
	set adapter=wlan
) else ( 
	set adapter=lan
)
echo INFO:adapter has switch to "%adapter%"
goto :EOF

:switchtocmd
cmd
goto :EOF

:showroute
route -4 print
goto :EOF

:dhcp
netsh int ipv4 set add name="%adapter%" source=dhcp
netsh int ipv4 set dns name="%adapter%" source=dhcp
goto :EOF

:checkip
echo %1 | findstr /r [0-9]\.[0-9] >NUL
goto :EOF

:delay
ping 127.0.0.1 -n %1 >NUL
goto :EOF

:backup
ipconfig /all >> c:\ipconf.txt
if %ERRORLEVEL% == 0 (
	echo INFO: current "ipconfig/all" has been backuped to c:\ipconf.txt
) else (
	echo ERROR: Maybe you need to run this script as administrator.
)
goto :EOF

rem *******************************
rem CONFIGURATIONS
rem *******************************
:conf1
set newIP=192.168.0.%ran%
set newSubnet=255.255.255.0
set newGW=192.168.0.1
set newDNS=202.96.128.68
goto :showconf

:conf2
set newIP=192.168.1.%ran%
set newSubnet=255.255.255.0
set newGW=192.168.1.1
set newDNS=202.96.128.68
goto :showconf

:conf3
set newIP=10.1.3.51
set newSubnet=255.255.255.0
set newGW=10.1.3.254
set newDNS=202.96.128.68
goto :showconf

:conf4
set newIP=112.91.99.174
set newSubnet=255.255.255.248
set newGW=112.91.99.169
set newDNS=221.5.88.88
goto :showconf

:conf5
set newIP=11.0.0.2
set newSubnet=255.255.255.0
set newGW=11.0.0.254
set newDNS=19.127.1.2
goto :showconf

:conf6
set newIP=19.127.49.170
set newSubnet=255.255.255.0
set newGW=19.127.49.254
set newDNS=19.127.1.2
goto :showconf

:conf7
set newIP=19.127.49.170
set newSubnet=255.255.255.0
set newGW=19.127.49.254
set newDNS=19.127.1.2
goto :showconf

:conf8
set newIP=1.1.1.2
set newSubnet=255.255.255.0
set newGW=1.1.1.1
set newDNS=202.96.128.68
goto :showconf

:conf9
set newIP=10.0.0.2
set newSubnet=255.255.255.0
set newGW=10.0.0.1
set newDNS=202.96.128.68
goto :showconf

:end
echo INFO: exit in 3 seconds...
call :delay 3

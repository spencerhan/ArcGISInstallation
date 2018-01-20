rem This script is designed to silently install ArcGIS for Desktop
rem designed by SpencerH
@echo off
echo ===================================================================================
echo Mapping local system drive.
net use Z: "\\localhost\c$"
rem Connecting to network drive.
echo //wairc.govt.nz/netlogon/logon.bat
set __COMPAT_LAYER=RunAsInvoker
rem Create staging folder to store unzipped setup files
rem if not exist, create a new staging folder
set staging_folder=%HomeDrive%\temp
IF NOT EXIST %staging_folder% mkdir %staging_folder%
rem Adding timestamp
set hh=%time:~0,2%
if "%time:~0,1%"==" " set hh=0%hh:~1,1%   
set timestamp=%hh%:%time:~3,2%_%date:~4,2%-%date:~7,2%-%date:~10,4%
rem path to the master installation file
set Master_File_path='%~dp0'

rem path to the ArcGIS installation file
set ArcGIS_File_path="%Master_File_path:~1,-1%\ArcGIS for Desktop 10.4.1\ArcGIS_Desktop_1041_151727\Desktop"
rem path to the Background geoprocessing tool installation file
set BackgroundGP_File_path="%Master_File_path:~1,-1%\ArcGIS for Desktop 10.4.1\DesktopBackgroundGP"
rem License manager Host Name
set LICNAME=arcintportlive
rem ArcGIS installation location
set installDir_arcgis="%HomeDrive%\Program Files (x86)\ArcGIS\Desktop10.4"

rem Python version 2.7 installation location
set installDir_python="%HomeDrive%\Python27"

rem Background_GEOPROCESSING installation location
set installBackgroundGP="%HomeDrive%\Python27\ArcGISx6410.4"

REM SOFTWARE_CLASS controls which version the users has access to
REM This is machine wide!
REM If the user wants to change this later it requires access to registry
REM Options are
REM basic = ArcView/Basic
REM standard = ArcEditor/Standard
REM advanced = ArcInfo/Advanced
REM this can later on be changed to user input
set basic=ArcView/Basic
set standard=ArcEditor/Standard 
set advanced=ArcInfo/Advanced
echo %timestamp%
echo License Manager = %LICNAME%
echo Staging folder Location = %staging_folder%
echo Master file location = %Master_File_path:~1,-1%
echo ArcGIS installation Location = %installDir_arcgis% 
echo Python installation Location = %installDir_python%
echo "Master File Path" = "%Master_File_path:~1,-1%"
echo "ArcGIS File Path" = %ArcGIS_File_path%
echo License Manager = %LICNAME%

rem move file from network drive to local drive.
echo ===================================================================================
echo "Copy installation file to local drive."

if NOT EXIST %HomeDrive%\temp\ArcGIS_Desktop_1041_151727 mkdir %HomeDrive%\temp\ArcGIS_Desktop
if NOT EXIST %HomeDrive%\temp\DesktopBackgroundGP mkdir %HomeDrive%\temp\ArcGIS_BackgroundGP
robocopy %ArcGIS_File_path% %staging_folder%\ArcGIS_Desktop /E /IS
robocopy %BackgroundGP_File_path% %staging_folder%\ArcGIS_BackgroundGP /E /IS

echo "Copy completed."
echo ===================================================================================

rem check whether previous ArcGIS installed
if NOT EXIST %installDir_arcgis% GOTO newInstall
echo "This machine has a previous ArcGIS copy installed."
%staging_folder%\ArcGIS_Desktop\Setup.exe ENABLEEUEI=0 ESRI_LICENSE_HOST=%LICNAME% SOFTWARE_CLASS=%basic% SEAT_PREFERENCE=Float DESKTOP_CONFIG=TRUE INSTALLDIR1=%installDir_python% /qb
If not EXIST "%WinDir%\SysWOW64" GOTO 32BIT
GOTO 64bit

:newInstall
echo "This machine has not got previous ArcGIS installed."
echo "Start installing fresh ArcGIS with basic license."
mkdir %installDir_arcgis%
if NOT EXIST %installDir_python% mkdir %installDir_python%
%staging_folder%\ArcGIS_Desktop\Setup.exe ENABLEEUEI=0 ESRI_LICENSE_HOST=%LICNAME% SOFTWARE_CLASS=%basic% SEAT_PREFERENCE=Float DESKTOP_CONFIG=TRUE INSTALLDIR1=%installDir_python% /qb
echo "ArcGIS Desktop installation COMPLETE."
If not EXIST %WinDir%\SysWOW64 (GOTO 32bit) ELSE GOTO 64bit
rem Installing in a 64bit environment.
:64bit
echo "This is a 64bit machine, start installing Background_GEOPROCESSING tool."
echo "Background_GEOPROCESSING File Path" = %staging_folder%\ArcGIS_BackgroundGP
if not EXIST %installBackgroundGP% mkdir %installBackgroundGP%
%staging_folder%\ArcGIS_BackgroundGP\Setup.exe  ENABLEEUEI=0 INSTALLDIR=%installBackgroundGP% /qb
echo "*			starting	after-installation	 configuration				*"
setx PATH "%installDir_python%\ArcGISx6410.4;%installDir_python%\ArcGISx6410.4\Scripts;%installDir_python%\ArcGISx6410.4\Lib\site-packages;"
path
GOTO install_end
rem This is a 32 bit machine. 
:32bit
rem 64bit Background processing tool will not be installed
echo "This is a 32 bit machine, Background_GEOPROCESSING tool will not be installed."
echo "*			starting	after-installation	 configuration				*"
echo "Adding Python Path"
setx PATH "%installDir_python%;%installDir_python%\Scripts;%installDir_python%\Lib\site-packages;"
path
GOTO install_end

:install_end
echo *					All 	Installation	COMPLETE					*
rem General configuration for setting up templates and default localtion to layer files etc.
rem 1. templates
rem reg /
echo ===================================================================================

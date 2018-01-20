@echo off
echo "Start installing ArcGIS for Desktop"
rem Use this to trigger installation batch in order to track errors
rem Create staging folder to store unzipped setup files
rem if not exist, create a new staging folder
set staging_folder=%HomeDrive%\temp
IF NOT EXIST %staging_folder% mkdir %staging_folder%
rem Adding timestamp
set hh=%time:~0,2%
if "%time:~0,1%"==" " set hh=0%hh:~1,1%   
set timestamp=%hh:~0,2%_%time:~3,2%_%date:~4,2%-%date:~7,2%-%date:~10,4%_ArcGIS_Installation
rem create a logfile
set logfile=%staging_folder%\%timestamp%.log
echo ************************************************************ > %logfile% 2>&1
echo *	              INSTALLING ARCGIS FOR DESKTOP             * >> %logfile% 2>&1
echo ************************************************************ >> %logfile% 2>&1
rem path to bat file location
SET batPath='%~dp0'
CALL "%batPath:~1,-1%Arc_Installation.bat" >> %logfile% 2>&1
echo "Installation & Configuration Completed"
echo "Start deleting installation files"
for /d %%i in (%staging_folder%\ArcGIS*) do rmdir /s /q "%%i"
echo "Installation file Deleted"
PAUSE
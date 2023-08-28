:: This determines the current date and stores it into a variable with format "YYYY-MM-DD_0000" and then calls the final backup procedures with that variable
:: Replacing the space with "0" for times before 10:00 

SET LOGFILE_DATE=%date:~-4,4%-%date:~-10,2%-%date:~-7,2%
SET LOGFILE_TIME=%TIME:~0,2%%TIME:~3,2%
IF "%LOGFILE_TIME:~0,1%" == " " SET LOGFILE_TIME=0%TIME:~1,1%%TIME:~3,2%

set dirname=%LOGFILE_DATE%_%LOGFILE_TIME%

:: The following code creates a backup of the most important databases and moves the file to the backup server immediately to a folder that is defined by parameter %dirname%
:: As we do not have that space problem on the server in Azure, we can store the backup in the usual folder and only move it to the backup server afterwards.

ECHO clean the intermediate directories, the /q makes sure that we are not prompted
DEL C:\_SERVER_BACKUP\*.* /q

ECHO create the final directory on the backup server.
mkdir D:\_SERVER_BACKUP_INTERMEDIATE\%dirname%

ECHO START to create the backups

ECHO master started
sqlcmd -S localhost\RSOSVR -dMasterDB -Ursoadmin -PM1kr0sch3m4 -Q "EXEC MasterDB.dbo.BackupDatabase 'master','C:\_SERVER_BACKUP\'"
ECHO master finished

ECHO model started
sqlcmd -S localhost\RSOSVR -dMasterDB -Ursoadmin -PM1kr0sch3m4 -Q "EXEC MasterDB.dbo.BackupDatabase 'model','C:\_SERVER_BACKUP\'"
ECHO model finished

ECHO msdb started
sqlcmd -S localhost\RSOSVR -dMasterDB -Ursoadmin -PM1kr0sch3m4 -Q "EXEC MasterDB.dbo.BackupDatabase 'msdb','C:\_SERVER_BACKUP\'"
ECHO msdb finished

ECHO TS_SWCM started
sqlcmd -S localhost\RSOSVR -dMasterDB -Ursoadmin -PM1kr0sch3m4 -Q "EXEC MasterDB.dbo.BackupDatabase 'TS_SWCM','C:\_SERVER_BACKUP\'"
ECHO TS_SWCM finished

ECHO tempBackups started
sqlcmd -S localhost\RSOSVR -dMasterDB -Ursoadmin -PM1kr0sch3m4 -Q "EXEC MasterDB.dbo.BackupDatabase 'tempBackups','C:\_SERVER_BACKUP\'"
ECHO tempBackups finished

ECHO MNRBCE_FC started
sqlcmd -S localhost\RSOSVR -dMasterDB -Ursoadmin -PM1kr0sch3m4 -Q "EXEC MasterDB.dbo.BackupDatabase 'MNRBCE_FC','C:\_SERVER_BACKUP\'"
ECHO MNRBCE_FC finished

ECHO Redbox4MNRBCE started
sqlcmd -S localhost\RSOSVR -dMasterDB -Ursoadmin -PM1kr0sch3m4 -Q "EXEC MasterDB.dbo.BackupDatabase 'Redbox4MNRBCE','C:\_SERVER_BACKUP\'"
ECHO Redbox4MNRBCE finished

ECHO RSOEUR_TR started
sqlcmd -S localhost\RSOSVR -dMasterDB -Ursoadmin -PM1kr0sch3m4 -Q "EXEC MasterDB.dbo.BackupDatabase 'RSOEUR_TR','C:\_SERVER_BACKUP\'"
ECHO RSOEUR_TR finished

ECHO RSOEUR_DR started
sqlcmd -S localhost\RSOSVR -dMasterDB -Ursoadmin -PM1kr0sch3m4 -Q "EXEC MasterDB.dbo.BackupDatabase 'RSOEUR_DR','C:\_SERVER_BACKUP\'"
Move C:\_SERVER_BACKUP\*.* \\mursos001.emea.nsn-net.net\_server_backup
ECHO RSOEUR_DR finished

ECHO RSOEUR_Code started
sqlcmd -S localhost\RSOSVR -dMasterDB -Ursoadmin -PM1kr0sch3m4 -Q "EXEC MasterDB.dbo.BackupDatabase 'RSOEUR_Code','C:\_SERVER_BACKUP\'"
ECHO RSOEUR_Code finished

ECHO MasterDB started
sqlcmd -S localhost\RSOSVR -dMasterDB -Ursoadmin -PM1kr0sch3m4 -Q "EXEC MasterDB.dbo.BackupDatabase 'MasterDB','C:\_SERVER_BACKUP\'"
ECHO MasterDB finished

ECHO MasterDB_past_years started
sqlcmd -S localhost\RSOSVR -dMasterDB -Ursoadmin -PM1kr0sch3m4 -Q "EXEC MasterDB.dbo.BackupDatabase 'MasterDB_past_years','C:\_SERVER_BACKUP\'"
ECHO MasterDB_past_years finished

ECHO RSOEUR_DR_past_years started
sqlcmd -S localhost\RSOSVR -dMasterDB -Ursoadmin -PM1kr0sch3m4 -Q "EXEC MasterDB.dbo.BackupDatabase 'RSOEUR_DR_past_years','C:\_SERVER_BACKUP\'"
ECHO RSOEUR_DR_past_years finished

ECHO RSOEUR_TR_past_years started
sqlcmd -S localhost\RSOSVR -dMasterDB -Ursoadmin -PM1kr0sch3m4 -Q "EXEC MasterDB.dbo.BackupDatabase 'RSOEUR_TR_past_years','C:\_SERVER_BACKUP\'"
ECHO RSOEUR_TR_past_years finished


ECHO FINISHED to create the backups


ECHO Move all files to the intermediate backup server, that can run for some time, depending on the network speed

ECHO STARTED to move to intermediate backup server (Directory D:\_SERVER_BACKUP_INTERMEDIATE\%dirname%)

Move C:\_SERVER_BACKUP\*.* D:\_SERVER_BACKUP_INTERMEDIATE\%dirname%

ECHO FINISHED to move to intermediate backup server (Directory D:\_SERVER_BACKUP_INTERMEDIATE\%dirname%)

:: This procedure zips the previously created folder. 

ECHO Starting Folder Backup to .zip Procedure...

:: This script converts the backed up folder into a .zip file. 

"C:\Program Files\7-Zip\7z.exe" a -tzip "D:\_SERVER_BACKUP_INTERMEDIATE\Backup %dirname%.zip" -r "D:\_SERVER_BACKUP_INTERMEDIATE\%dirname%" -mx5

ECHO Folder from %dirname% backed up and zipped. 

:: Move zipped folder into final destination. 

Move "D:\_SERVER_BACKUP_INTERMEDIATE\Backup %dirname%.zip" "\\10.157.3.93\backups\DH01\SQL_server_backups\2023"

ECHO Backup moved from Temp Storage to Backup Server. 

:: Delete intermediate folder. 

rmdir /q /s 2>NUL "D:\_SERVER_BACKUP_INTERMEDIATE\"
mkdir D:\_SERVER_BACKUP_INTERMEDIATE\

ECHO %dirname% and Intermediate folder deleted. 

:: Code by brduarte 2023-01-13
:: Edited by brduarte 2023-03-03 due to issues zipping and inserting '0' before 10am times

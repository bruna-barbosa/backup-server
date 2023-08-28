# Daily Server Backup
.BAT file for daily backing up a Data House Server.

##	1. Python Script: Zip folders in SQL Server 
		https://www.sqlshack.com/prepare-zip-or-rar-files-in-sql-server-using-xp_cmdshell-t-sql/
		
##	2. Generate Data Script in SQL Server
		Using the Generate Scripts option	
		i. Connect to a server that's running SQL Server.
		ii. Expand the Databases node.
		iii. Right-click AdventureWorks2016 > Tasks > Generate Scripts:
		iv. The Introduction page opens.
		v. Select Next to open the Set Scripting Options page.
		vi. Select OK, and then select Next.
		
##	3. SQL Existing Server Backup
		https://www.folkstalk.com/2022/09/script-sql-backup-database-sql-server-with-code-examples.html
		i. Launch SQL Server Management Studio (SSMS) and connect to your SQL Server instance.
		ii. Expand the Databases node in Object Explorer.
		iii. Right-click the database, hover over Tasks, and select Back up.
		iv. Under Destination, confirm that the path for your backup is correct.
		
##	4. SQL Server Backup Automation
		i. Create stored procedure to Back up your databases.
		ii. Download SQLCMD tool (if applicable).
		iii. Create batch file using text editor.
		
##	5. SQL Server Backup and Restore Automation 
		i. Configure variables
		ii. To obtain the logical and physical file names for the source and target databases: From Object Explorer in SQL Server Management Studio: Right click on source
		
##	6. Scheduling a backup in SQL Server
		Use Maintenance Plan to Create Scheduled Backups
		i. Click Toolbox on the upper bar, select Back Up Database Task and drag it to the right blank, then double-click this task.
		ii. In the prompt window, choose Backup type first (Full/Differential/Transaction Log), then select specific one or more databases you want to back up.
		
##	7. Creating a backup job in SQL Server
		i. Open SQL Server Management Studio. 
		ii. Expand SQL Server Agent, and expand Jobs. 
		iii. Right-click the job you want to create a backup script for, and then select Script Job as. 
		iv. Select CREATE To or DROP To, then select New Query Editor Window, File, or Clipboard to select a destination for the script.



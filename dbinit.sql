/* USE BELOW WHEN CREATING FOR FIRST TIME */

/*

CREATE LOGIN cclogin2 WITH PASSWORD = '123Next!';
CREATE DATABASE ccdb2;

USE [ccdb2]
GO
EXEC dbo.sp_changedbowner @loginame = N'cclogin2'
GO

*/

CREATE LOGIN cclogin WITH PASSWORD = '123Next!';
USE [ccdb]
GO
EXEC dbo.sp_changedbowner @loginame = N'cclogin'
GO

/* to UPDATE  */
update [ccdb].[dbo].[SYS_CONFIG] SET VALUE='https://dcc.serviceops.cloudaz.net:443' WHERE ID=20
update [ccdb].[dbo].[SYS_CONFIG] SET VALUE='failover:(tcp://dcc.serviceops.cloudaz.net:61616)' WHERE ID=11
update [ccdb].[dbo].[SYS_CONFIG] SET VALUE='https://dcc.serviceops.cloudaz.net:8443' WHERE ID=32

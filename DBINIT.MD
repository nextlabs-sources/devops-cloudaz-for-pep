# update to match elastic search docker name
lets say if you --link elasticsearch:es
then you have to update below


update [ccdb].[dbo].[SYS_CONFIG] set VALUE='es' where id=127
select * from [ccdb].[dbo].[SYS_CONFIG] where id = 127


# to delete all tables
USE ccdb
-- Disable all referential integrity constraints
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
GO

-- Drop all PKs and FKs
declare @sql nvarchar(max)
SELECT @sql = STUFF((SELECT '; ' + 'ALTER TABLE ' + Table_Name  +'  drop constraint ' + Constraint_Name  from Information_Schema.CONSTRAINT_TABLE_USAGE ORDER BY Constraint_Name FOR XML PATH('')),1,1,'')
EXECUTE (@sql)
GO

-- Drop all tables
EXEC sp_MSforeachtable 'DROP TABLE ?'
GO

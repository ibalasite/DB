DECLARE @START_SEQ INT = 0; 
SET 
    @START_SEQ = (
        SELECT 
            MAX(id)+ 1 
        from 
            members 
        where 
            id < 1000000000
    ); IF OBJECT_ID('memberseq') IS NOT NULL 
DROP 
    SEQUENCE [dbo].[memberseq] DECLARE @sql NVARCHAR(MAX) 
SET 
    @sql = 'CREATE SEQUENCE [dbo].[memberseq] 
 AS [int]
 START WITH ' + CONVERT(
        varchar(10), 
        @START_SEQ
    ) + ' INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 1000000000
 CYCLE
 CACHE 20' 
select 
    @sql EXEC(@sql) 
SELECT 
    * 
FROM 
    sys.sequences 
WHERE 
    name = 'memberseq'; --select NEXT VALUE FOR dbo.memberseq
    ----------- drop id identity
    DECLARE @tablename nvarchar(100) = 'members' DECLARE @sourceid nvarchar(100) = 'ID' DECLARE @subsql NVARCHAR(MAX) -- 建立一個tempid default 指向 memberseq
    --alter table members add tempId int NOT NULL default FOR dbo.memberseq;
    --ALTER TABLE testmembers add tempId int NOT NULL default NEXT VALUE FOR dbo.memberseq
    --SET @subsql ='ALTER TABLE '+@tablename + ' add tempId int NOT NULL default NEXT VALUE FOR dbo.memberseq'
SET 
    @subsql = 'ALTER TABLE ' + @tablename + ' add tempId int ' exec(@subsql) 
set 
    @subsql = ' update ' + @tablename + ' set tempId = ' + @sourceid + ';' --update testmembers set tempId = id;
    exec(@subsql) 
SET 
    @subsql = 'ALTER TABLE ' + @tablename + ' ALTER COLUMN tempID int NOT NULL ' exec(@subsql) 
SET 
    @subsql = 'ALTER TABLE ' + @tablename + ' ADD CONSTRAINT DF__' + @sourceid + '__Constraint DEFAULT (NEXT VALUE FOR dbo.memberseq) FOR tempID ' exec(@subsql) ---------- delete pk start
    DECLARE @consname NVARCHAR(100) DECLARE @getid CURSOR 
SET 
    @getid = CURSOR FOR 
SELECT 
    CONSTRAINT_NAME 
FROM 
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE 
    TABLE_NAME = @tablename 
    and CONSTRAINT_NAME like 'PK__%'; OPEN @getid FETCH NEXT 
FROM 
    @getid INTO @consname WHILE @@FETCH_STATUS = 0 BEGIN 
select 
    @consname 
SET 
    @subsql = 'ALTER TABLE ' + @tablename + ' DROP CONSTRAINT ' + @consname; 
select 
    @subsql EXEC(@subsql) FETCH NEXT 
FROM 
    @getid INTO @consname END CLOSE @getid DEALLOCATE @getid ----- delete pk end
    --drop column id
SET 
    @subsql = 'ALTER TABLE ' + @tablename + ' DROP column ' + @sourceid EXEC(@subsql) -- rename
set 
    @subsql = 'exec sp_rename ''' + @tablename + '.tempId'', ''' + @sourceid + ''', ''COLUMN'''; EXEC(@subsql) -- add pk
SET 
    @subsql = 'ALTER TABLE ' + @tablename + ' ADD CONSTRAINT PK__' + @tablename + '__' + @sourceid + ' PRIMARY KEY (' + @sourceid + ') ' EXEC(@subsql)

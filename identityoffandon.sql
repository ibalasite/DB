Create PROCEDURE USP_INSMEMBERS @id int, 
@name varchar(255) AS BEGIN BEGIN TRAN T1; declare @current_ident int declare @sessionstartrecord int 
select 
    @sessionstartrecord = 1000000000 
select 
    @current_ident = max(id) 
from 
    dbo.members 
where 
    id < @sessionstartrecord --in order to table lock and  IDENT_CURRENT() is not transaction-safe. 
SET 
    IDENTITY_INSERT members on insert into dbo.members(id, name) 
values 
    (@id, @name) 
SET 
    IDENTITY_INSERT dbo.members off 
select 
    @current_ident = max(id) 
from 
    dbo.members 
where 
    id < @sessionstartrecord --confirm the value must be < @sessionstartrecord
    DBCC CHECKIDENT (
        'members', RESEED, @current_ident
    ); COMMIT TRAN T1; END

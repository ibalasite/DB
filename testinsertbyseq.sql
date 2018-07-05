DECLARE @seq INT = 1;
declare @sessionstartrecord int =1000000000
DECLARE @tmpid INT ;
DECLARE @startid INT ;
select @startid = max(id) from dbo.members where id > @sessionstartrecord

select @startid = ISNULL(@startid,@sessionstartrecord )
set @tmpid = @startid;
--select @tmpid
DECLARE @tmpname varchar(255);
WHILE @seq <= 1000
BEGIN
  BEGIN TRAN t1;
  set @tmpid += 1;
  set @tmpname = CONCAT('custom',@seq);
  --select @tmpid,@tmpname
  --exec USP_INSMEMBERS @tmpid, @tmpname;
  INSERT into dbo.members(id,name)values(@tmpid,@tmpname);
  COMMIT TRAN T1;
  SET @seq += 1;
  END
select count(*) from members where id > @startid
select * from members

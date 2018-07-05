DECLARE @seq INT = 0;
declare @sessionstartrecord int =1000000000

DECLARE @startid INT ;
select @startid = ISNULL(max(id),@seq) from dbo.members where id < @sessionstartrecord
WHILE @seq < 1000
BEGIN
  BEGIN TRAN t1;
  INSERT into dbo.members(name)values(CONCAT('legacy' ,@seq));
  COMMIT TRAN T1;
  SET @seq += 1;
END
select count(*) from members where id > @startid and id < @sessionstartrecord
select * from members


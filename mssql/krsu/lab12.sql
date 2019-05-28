use Boreas_test;
GO


ALTER TRIGGER dbo.TR_Клиенты_Insert
ON dbo.Клиенты
INSTEAD OF INSERT
AS
BEGIN 
 
IF EXISTS (SELECT 1 FROM inserted)
 begin print '  -- I am an insert'
  select * From inserted
  end
ELSE
  print '  --lol'
END


insert into dbo.Клиенты (Адрес,  Город)
values ('dsd', 'tashkent')
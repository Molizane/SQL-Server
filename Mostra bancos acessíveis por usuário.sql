
if not object_id('tempdb..#Users') is null
  drop table #Users
go


if not object_id('tempdb..#Acesso') is null
  drop table #Acesso
go

create table #Users
(
  [sid] varbinary(100) null,
  [Login Name] varchar(100) null
)

create table #Acesso
(
  [User ID] varchar(max),
  [Server Login] varchar(max),
  [Database Role] varchar(max),
  [Database] varchar(max)
)


declare
  @cmd1 nvarchar(500),
  @cmd2 nvarchar(500)

set @cmd1 = '
INSERT INTO #Users ([sid], [Login Name])
  SELECT sid, loginname
  FROM master.dbo.syslogins

INSERT INTO #Acesso
  SELECT su.[name], u.[Login Name], sug.name, ''?''
  FROM [?].[dbo].[sysusers] su
  LEFT OUTER JOIN #Users u
    ON su.sid = u.sid
  LEFT OUTER JOIN ([?].[dbo].[sysmembers] sm
                   INNER JOIN [?].[dbo].[sysusers] sug
                      ON sm.groupuid = sug.uid)
    ON su.uid = sm.memberuid
 WHERE su.hasdbaccess = 1
 AND su.[name] != ''dbo''
'

exec sp_MSforeachdb @command1 = @cmd1

select *
from #Acesso
--where upper([User ID]) like '%BAMOLIZA%'
group by [User ID], [Server Login], [Database Role], [Database]
--order by upper([User ID]), [Database]

drop table #Users
drop table #Acesso

GO

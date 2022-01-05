set nocount on

declare
  @TableName varchar(max) = 'MovimentoSHF', -- Replace 'NewsItem' with your table name
  @TableSchema varchar(max) = 'SHF.Models',  -- Replace 'Markets' with your schema name
  @Spaces varchar(100)

declare @TblRows table
(
  Row varchar(200)
)

insert into @TblRows
select 'using System;'

insert into @TblRows
select 'using System.Runtime.Serialization;'

insert into @TblRows
select 'using System.Xml.Serialization;'

insert into @TblRows
select ''

if isnull(@TableSchema, '') <> ''
begin
  insert into @TblRows
  select 'namespace ' + @TableSchema

  insert into @TblRows
  select '{'
  
  set @Spaces = '    '
end
else
begin
  set @Spaces = ''
end

insert into @TblRows
select @Spaces + '[XmlRoot(ElementName = "' + @TableName + '", Namespace = "")] // XML'

insert into @TblRows
select @Spaces + '[DataContract(Name = "' + @TableName + '")] // Json/Bson'

insert into @TblRows
select @Spaces + 'public class ' + @TableName

insert into @TblRows
select @Spaces + '{'

insert into @TblRows
select @Spaces + '    #region Instance Properties'

insert into @TblRows
select ''

insert into @TblRows
select @Spaces + '    [XmlElement(ElementName = "'+ColumnName+'")]' + char(13) + char(10) + 
       @Spaces + '    [DataMember(Name = "'+ColumnName+'")]' + char(13) + char(10) + 
       @Spaces + '    public ' + ColumnType + ' ' + ColumnName+ ' { get; set; }' + char(13) + char(10) + ' '
from (select c.COLUMN_NAME as ColumnName,
             case c.DATA_TYPE
               when 'bigint' then case c.IS_NULLABLE
                   when 'YES' then 'Int64?'
                   else 'Int64'
                   end
               when 'binary' then 'Byte[]'
               when 'bit' then case c.IS_NULLABLE
                   when 'YES' then 'bool?'
                   else 'bool'
                 end
               when 'char' then 'string'
               when 'date' then case c.IS_NULLABLE
                   when 'YES' then 'DateTime?'
                   else 'DateTime'
                 end
               when 'datetime' then case c.IS_NULLABLE
                   when 'YES' then 'DateTime?'
                   else 'DateTime'
                 end
               when 'datetime2' then case c.IS_NULLABLE
                   when 'YES' then 'DateTime?'
                   else 'DateTime'
                 end
               when 'datetimeoffset' then case c.IS_NULLABLE
                   when 'YES' then 'DateTimeOffset?'
                   else 'DateTimeOffset'
                 end
               when 'decimal' then case c.IS_NULLABLE
                   when 'YES' then 'decimal?'
                   else 'decimal'
                 end
               when 'float' then case c.IS_NULLABLE
                   when 'YES' then 'Single?'
                   else 'Single'
                 end
               when 'image' then 'Byte[]'
               when 'int' then case c.IS_NULLABLE
                   when 'YES' then 'int?'
                   else 'int'
                 end
               when 'money' then case c.IS_NULLABLE
                   when 'YES' then 'decimal?'
                   else 'decimal'
                 end
               when 'nchar' then 'string'
               when 'ntext' then 'string'
               when 'numeric' then case c.IS_NULLABLE
                   when 'YES' then 'decimal?'
                   else 'decimal'
                 end
               when 'nvarchar' then 'string'
               when 'real' then case c.IS_NULLABLE
                   when 'YES' then 'Double?'
                   else 'Double'
                 end
               when 'smalldatetime' then case c.IS_NULLABLE
                   when 'YES' then 'DateTime?'
                   else 'DateTime'
                 end
               when 'smallint' then case c.IS_NULLABLE
                   when 'YES' then 'Int16?'
                   else 'Int16'
                 end
               when 'smallmoney' then case c.IS_NULLABLE
                   when 'YES' then 'decimal?'
                   else 'decimal'
                 end
               when 'text' then 'string'
               when 'time' then case c.IS_NULLABLE
                   when 'YES' then 'TimeSpan?'
                   else 'TimeSpan'
                 end
               when 'timestamp' then 'Byte[]'
               when 'tinyint' then case c.IS_NULLABLE
                   when 'YES' then 'Byte?'
                   else 'Byte'
                 end
               when 'uniqueidentifier' then case c.IS_NULLABLE
                   when 'YES' then 'Guid?'
                   else 'Guid'
                 end
               when 'varbinary' then 'Byte[]'
               when 'varchar' then 'string'
               else 'Object'
             end as ColumnType,
             c.ORDINAL_POSITION
           from INFORMATION_SCHEMA.COLUMNS c
           where c.TABLE_NAME = @TableName
           --and isnull(@TableSchema, c.TABLE_SCHEMA) = c.TABLE_SCHEMA
           ) t
order by t.ORDINAL_POSITION

insert into @TblRows
select @Spaces + '    #endregion Instance Properties'

insert into @TblRows
select @Spaces + '}'

if (isnull(@TableSchema, '') <> '')
begin
    insert into @TblRows
    select  '}'
end

--select * from @TblRows

declare
  @row nvarchar(500)

declare RowsCsr cursor fast_forward for
  select *
  from @TblRows

open RowsCsr

while 1 = 1
begin
  fetch next from RowsCsr
  into @row

  if @@fetch_status <> 0
    break

  print @row
end

close RowsCsr
deallocate RowsCsr

set nocount off
go

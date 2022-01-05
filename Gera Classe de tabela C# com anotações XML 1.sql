set nocount on

declare 
  @TableName sysname = 'MovimentoSHF'

declare @tblresult table
(
  result varchar(200)
)

insert into @tblresult
select 'using System.Runtime.Serialization;'

insert into @tblresult
select 'using System.Xml.Serialization;'

insert into @tblresult
select ''

insert into @tblresult
select 'namespace SHF.Models'

insert into @tblresult
select '{'

insert into @tblresult
select ''

insert into @tblresult
select '    [XmlRoot(ElementName = "' + @TableName + '", Namespace = "")] // XML'

insert into @tblresult
select '    [DataContract(Name = "' + @TableName + '")] // Json/Bson'

insert into @tblresult
select '    public class ' + upper(substring(@TableName, 1, 1)) + substring(@TableName, 2, len(@TableName) - 1)
insert into @tblresult
select '    {'

insert into @tblresult
select '        [XmlElement(ElementName = "' + ColumnName + '")]' + Char(13) + Char(10) +
       '        [DataMember(Name = "' + ColumnName + '")]' + Char(13) + Char(10) +
       '        public ' + ColumnType + NullableSign + ' ' + 
       upper(substring(ColumnName, 1, 1)) + substring(ColumnName, 2, len(ColumnName) - 1) + ' { get; set; }' + 
       Char(13) + Char(10) + ' '
from (select replace(col.name, ' ', '_') ColumnName,
             column_id ColumnId,
             case typ.name 
                 when 'bigint' then 'long'
                 when 'binary' then 'byte[]'
                 when 'bit' then 'bool'
                 when 'char' then 'string'
                 when 'date' then 'DateTime'
                 when 'datetime' then 'DateTime'
                 when 'datetime2' then 'DateTime'
                 when 'datetimeoffset' then 'DateTimeOffset'
                 when 'decimal' then 'decimal'
                 when 'float' then 'double'
                 when 'image' then 'byte[]'
                 when 'int' then 'int'
                 when 'money' then 'decimal'
                 when 'nchar' then 'string'
                 when 'ntext' then 'string'
                 when 'numeric' then 'decimal'
                 when 'nvarchar' then 'string'
                 when 'real' then 'float'
                 when 'smalldatetime' then 'DateTime'
                 when 'smallint' then 'short'
                 when 'smallmoney' then 'decimal'
                 when 'text' then 'string'
                 when 'time' then 'TimeSpan'
                 when 'timestamp' then 'long'
                 when 'tinyint' then 'byte'
                 when 'uniqueidentifier' then 'Guid'
                 when 'varbinary' then 'byte[]'
                 when 'varchar' then 'string'
                 else 'UNKNOWN_' + typ.name
             end ColumnType,
             case 
                 when col.is_nullable = 1 and typ.name in ('bigint', 'bit', 'date', 'datetime', 'datetime2', 'datetimeoffset', 'decimal', 'float', 'int', 'money', 'numeric', 'real', 'smalldatetime', 'smallint', 'smallmoney', 'time', 'tinyint', 'uniqueidentifier') 
                 then '?' 
                 else '' 
             end NullableSign
      from sys.columns col
      join sys.types typ 
        on col.system_type_id = typ.system_type_id 
       and col.user_type_id = typ.user_type_id
    where object_id = object_id(@TableName)) t
order by ColumnId

insert into @tblresult
select '    }'

insert into @tblresult
select '}'

--select result from @tblresult

declare
  @row nvarchar(500)

declare RowsCsr cursor fast_forward for
  select result 
  from @tblresult

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

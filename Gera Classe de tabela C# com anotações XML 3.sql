set nocount on

declare
  @Schema varchar(max) = N'dbo',
  @TableName varchar(max) = N'MovimentoSHF',
  @Namespace varchar(max) = N'SHF.Models',

  @CrLf varchar(1) = char(13), --+ char(10),
  --@Tab varchar(1) = char(9),
  @Tab varchar(4) = '    ',
  @result varchar(max) = ''

declare
  @PrivateProp varchar(100) = @CrLf +
                              @Tab + @Tab + 'private <ColumnType> _<ColName>;' + @CrLf,

  @PublicProp varchar(500) = @CrLf +
                             @Tab + @Tab + '[XmlElement(ElementName = "<ColumnName>")]' + @CrLf +
                             @Tab + @Tab + '[DataMember(Name = "<ColumnName>")]' + @CrLf +
                             @Tab + @Tab + 'public <ColumnType> <ColName> '  + @CrLf +
                             @Tab + @Tab + '{' + @CrLf +
                             @Tab + @Tab + '   get { return _<ColName>; }' + @CrLf +
                             @Tab + @Tab + '   set {' + @CrLf +
                             @Tab + @Tab + '         _<ColName> = value;' + @CrLf +
                             @Tab + @Tab + '         base.RaisePropertyChanged();' + @CrLf +
                             @Tab + @Tab + '       }' + @CrLf +
                             @Tab + @Tab + '}' + @CrLf,

  @RPCProc varchar(max) = @CrLf +
                          @Tab + @Tab + 'public event PropertyChangedEventHandler PropertyChanged;' + @CrLf +
                          @Tab + @Tab + 'private void RaisePropertyChanged([CallerMemberName] string caller = "")' + @CrLf +
                          @Tab + @Tab + '{ ' + @CrLf +
                          @Tab + @Tab + '   if (PropertyChanged != null) ' + @CrLf +
                          @Tab + @Tab + '   {' + @CrLf +
                          @Tab + @Tab + '       PropertyChanged(this, new PropertyChangedEventArgs(caller));' + @CrLf +
                          @Tab + @Tab + '   }' + @CrLf +
                          @Tab + @Tab + '}',

  @PropChanged varchar(200) = @CrLf +
                              @Tab + @Tab + 'protected override void AfterPropertyChanged(string propertyName)' + @CrLf +
                              @Tab + @Tab + '{' + @CrLf +
                              @Tab + @Tab + '   System.Diagnostics.Debug.WriteLine("' + @TableName + ' property changed: " + propertyName);' + @CrLf +
                              @Tab + @Tab + '}'

set @result = 'using System;' + @CrLf +
              'using System.Runtime.Serialization;' + @CrLf +
              'using System.Xml.Serialization;' + @CrLf + @CrLf +
              'namespace ' + @Namespace  + @CrLf + '{' + @CrLf +
              '   [XmlRoot(ElementName = "' + @TableName + '")] // XML' + @CrLf +
              '   [DataContract(Name = "' + @TableName + '")] // Json/Bson' + @CrLf +
              '   public class ' + @TableName + ' : ObservableObject' + @CrLf +
              '   {' + @CrLf +
              @Tab + @Tab + '#region Instance Properties' + @CrLf

select @result = @result
                 +
                 replace(replace(replace(@PrivateProp, '<ColumnName>', ColumnName), '<ColumnType>', ColumnType), '<ColName>', ColumnName)
                 +
                 replace(replace(replace(@PublicProp, '<ColumnName>', ColumnName), '<ColumnType>', ColumnType), '<ColName>', ColumnName)
from (select c.COLUMN_NAME as ColumnName, 
             case c.DATA_TYPE
                 when 'bigint' then
                     case c.IS_NULLABLE
                         when 'YES' then 'Int64?' else 'Int64' end
                 when 'binary' then 'Byte[]'
                 when 'bit' then
                     case c.IS_NULLABLE
                         when 'YES' then 'Boolean?' else 'Boolean' end
                 when 'char' then 'String'
                 when 'date' then
                     case c.IS_NULLABLE
                         when 'YES' then 'DateTime?' else 'DateTime' end
                 when 'datetime' then
                     case c.IS_NULLABLE
                         when 'YES' then 'DateTime?' else 'DateTime' end
                 when 'datetime2' then
                     case c.IS_NULLABLE
                         when 'YES' then 'DateTime?' else 'DateTime' end
                 when 'datetimeoffset' then
                     case c.IS_NULLABLE
                         when 'YES' then 'DateTimeOffset?' else 'DateTimeOffset' end
                 when 'decimal' then
                     case c.IS_NULLABLE
                         when 'YES' then 'Decimal?' else 'Decimal' end
                 when 'float' then
                     case c.IS_NULLABLE
                         when 'YES' then 'Single?' else 'Single' end
                 when 'image' then 'Byte[]'
                 when 'int' then
                     case c.IS_NULLABLE
                         when 'YES' then 'Int32?' else 'Int32' end
                 when 'money' then
                     case c.IS_NULLABLE
                         when 'YES' then 'Decimal?' else 'Decimal' end
                 when 'nchar' then 'String'
                 when 'ntext' then 'String'
                 when 'numeric' then
                     case c.IS_NULLABLE
                         when 'YES' then 'Decimal?' else 'Decimal' end
                 when 'nvarchar' then 'String'
                 when 'real' then
                     case c.IS_NULLABLE
                         when 'YES' then 'Double?' else 'Double' end
                 when 'smalldatetime' then
                     case c.IS_NULLABLE
                         when 'YES' then 'DateTime?' else 'DateTime' end
                 when 'smallint' then
                     case c.IS_NULLABLE
                         when 'YES' then 'Int16?' else 'Int16'end
                 when 'smallmoney' then
                     case c.IS_NULLABLE
                         when 'YES' then 'Decimal?' else 'Decimal' end
                 when 'text' then 'String'
                 when 'time' then
                     case c.IS_NULLABLE
                         when 'YES' then 'TimeSpan?' else 'TimeSpan' end
                 when 'timestamp' then
                     case c.IS_NULLABLE
                         when 'YES' then 'DateTime?' else 'DateTime' end
                 when 'tinyint' then
                     case c.IS_NULLABLE
                         when 'YES' then 'Byte?' else 'Byte' end
                 when 'uniqueidentifier' then 'Guid'
                 when 'varbinary' then 'Byte[]'
                 when 'varchar' then 'String'
                 else 'Object'
             end as ColumnType,
             c.ORDINAL_POSITION
      from INFORMATION_SCHEMA.COLUMNS c
      where c.TABLE_NAME = @TableName
      and isnull(@Schema, c.TABLE_SCHEMA) = c.TABLE_SCHEMA) t
order by t.ORDINAL_POSITION

select @result = @result + @CrLf +
                 @Tab + @Tab + '#endregion Instance Properties' + @CrLf +
                 @Tab + @RPCProc + @CrLf +
                 @Tab + @PropChanged + @CrLf +
                 @Tab + '}' + @CrLf +
                 '}'

-- You will want to change nvarchar(max) to nvarchar(50), varchar(50) or whatever matches exactly with the string column you will be searching against
declare
  @SplitStringTable table (row nvarchar(200) not null)

declare
  @StringToSplit nvarchar(max) = @result,
  @SplitEndPos int,
  @SplitValue nvarchar(max),
  @SplitDelim nvarchar(2) = @CrLf,
  @SplitStartPos int = 1

set @SplitEndPos = charindex(@SplitDelim, @StringToSplit, @SplitStartPos)

while @SplitEndPos > 0
begin
  set @SplitValue = substring(@StringToSplit, @SplitStartPos, (@SplitEndPos - @SplitStartPos))

  insert into @SplitStringTable values (@SplitValue)

  set @SplitStartPos = @SplitEndPos + 1
  set @SplitEndPos = charindex(@SplitDelim, @StringToSplit, @SplitStartPos)
end

set @SplitValue = substring(@StringToSplit, @SplitStartPos, 2147483647)
insert @SplitStringTable values(@SplitValue)

declare SplitTable cursor fast_forward for
  select *
  from @SplitStringTable

open SplitTable

while 1 = 1
begin
  fetch next from SplitTable
  into @result

  if @@fetch_status <> 0
    break

  print rtrim(@result)
end

close SplitTable
deallocate SplitTable

set nocount off
go

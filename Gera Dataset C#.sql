set nocount on

declare
  @TableName sysname = '',
  @TABLE_QUALIFIER varchar(100),
  @TABLE_OWNER varchar(100),
  @TABLE_NAME varchar(100),
  @COLUMN_NAME varchar(100),
  @KEY_SEQ INT,
  @PK_NAME varchar(100),
  @cnt int

declare @tbldataset table
(
  row varchar(200)
)

declare @tbindex table
(
  TABLE_QUALIFIER varchar(100),
  TABLE_OWNER varchar(100),
  TABLE_NAME varchar(100),
  COLUMN_NAME varchar(100),
  KEY_SEQ INT,
  PK_NAME varchar(100)
)

insert into @tbldataset
select 'using System;'

insert into @tbldataset
select 'using System.Data;'

insert into @tbldataset
select ''

insert into @tbldataset
select 'namespace DataTables'

insert into @tbldataset
select '{'

insert into @tbldataset
select '    public class DmKittx'

insert into @tbldataset
select '    {'

insert into @tbldataset
select '        private DataSet dataset;'

insert into @tbldataset
select ''

insert into @tbldataset
select '        public DataSet Dataset'

insert into @tbldataset
select '        {'

insert into @tbldataset
select '            get'

insert into @tbldataset
select '            {'

insert into @tbldataset
select '                return dataset;'

insert into @tbldataset
select '            }'

insert into @tbldataset
select '        }'

insert into @tbldataset
select ''

insert into @tbldataset
select '        public SHFDM()'

insert into @tbldataset
select '        {'

insert into @tbldataset
select '            dataset = new DataSet();'

insert into @tbldataset
select ''

insert into @tbldataset
select '            DataTable tb;'

insert into @tbldataset
select '            DataColumn column;'

insert into @tbldataset
select '            DataColumn[] primaryKey;'

declare @tbtabelas table
(
  nome varchar(50)
)

insert into @tbtabelas select 'MovimentoSHF'
insert into @tbtabelas select 'MovSHFTeletrabalho'
insert into @tbtabelas select 'MovSHFTeletrabalhoHist'

declare csr cursor fast_forward for
  select nome from @tbtabelas

open csr

while 1 = 1
begin
  fetch next
  from csr
  into @TableName

  if @@fetch_status <> 0
    break

  insert into @tbldataset
  select ''

  insert into @tbldataset
  select '            //' + @TableName

  insert into @tbldataset
  select '            tb = new DataTable("' + @TableName + '");'

  insert into @tbldataset
  select Char(13) + Char(10)+
         '            column = new DataColumn("' + ColumnName + '", typeof(' + ColumnType + '));' + Char(13) + Char(10) +
         '            column.AllowDBNull = ' + case when NullableSign = '?' then 'true' else 'false' end + ';' + Char(13) + Char(10) +
         '            tb.Columns.Add(column);' + Char(13) + Char(10)
  from (select lower(replace(col.name, ' ', '_')) ColumnName,
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

  insert into @tbldataset
  select ''

  delete from @tbindex

  insert into @tbindex
    exec [sys].[sp_pkeys] @TableName, dbo

  select @cnt = count(*)
  from @tbindex

  if @cnt > 0
  begin
    insert into @tbldataset
    select '            primaryKey = new DataColumn[' + cast(@cnt as varchar(20)) + '];'

    set @cnt = 0

    declare csrindex cursor fast_forward for
      select *
      from @tbindex

    open csrindex

    while 1 = 1
    begin
      fetch next
      from csrindex
      into @TABLE_QUALIFIER, @TABLE_OWNER, @TABLE_NAME, @COLUMN_NAME, @KEY_SEQ, @PK_NAME

      if @@fetch_status <> 0
        break

      insert into @tbldataset
      select '            primaryKey[' + cast(@cnt as varchar(20)) + '] = tb.Columns["' + lower(@COLUMN_NAME) + '"];'

      set @cnt = @cnt + 1
    end

    close csrindex
    deallocate csrindex

    insert into @tbldataset
    select '            tb.PrimaryKey = primaryKey;'

    insert into @tbldataset
    select ''
  end

  insert into @tbldataset
  select '            Dataset.Tables.Add(tb);'
end

close csr
deallocate csr

insert into @tbldataset
select '        }'

insert into @tbldataset
select '    }'

insert into @tbldataset
select '}'

--select row from @tbldataset

declare
  @row nvarchar(1000)

declare RowsCsr cursor fast_forward for
  select row
  from @tbldataset

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

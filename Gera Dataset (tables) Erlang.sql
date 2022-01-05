set nocount on

declare @tbldataset table
(
  row varchar(200)
)

declare @tbtabelas table
(
  nome varchar(50),
  indice varchar(100)
)

insert into @tbtabelas select 'MovimentoSHF', 'Matricula,Movimento,Empresa,Filial'
insert into @tbtabelas select 'MovSHFTeletrabalho', 'Matricula,Movimento,Empresa,Filial'
insert into @tbtabelas select 'MovSHFTeletrabalhoHist', 'Matricula,Movimento,Empresa,Filial,DataMovimento'

declare
  @TableName  sysname = '',
  @ColumnName varchar(100), 
  @ColumnId   int,
  @ColName    varchar(100) = '',
  @Spaces     varchar(100)

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

  declare csr2 cursor fast_forward for
    select lower(replace(col.name, ' ', '_')) ColumnName, column_id ColumnId        
    from sys.columns col
    join sys.types typ
      on col.system_type_id = typ.system_type_id
     and col.user_type_id = typ.user_type_id
     where object_id = object_id(@TableName)
     order by ColumnId

  open csr2

  set @TableName = '-record(' + @TableName + ', {'
  set @Spaces = ''

  declare
    @l int = Len(@TableName)

  while @l > 0
    begin
      set @Spaces = @Spaces + ' '
      set @l = @l - 1
    end

  set @ColName = ''
        
  while 1 = 1
     begin
        fetch next 
        from csr2 
        into @ColumnName, @ColumnId

        if @@fetch_status <> 0
           break

        if @ColName <> ''
           if @TableName <> ''
           begin
             insert into @tbldataset
                select @TableName + @ColName + ','
           
             set @TableName = ''
           end
           else
             insert into @tbldataset
               select @Spaces + @ColName + ','

        set @ColName = @ColumnName
     end

  close csr2
  deallocate csr2

  if @ColName <> ''
     begin
        insert into @tbldataset
          select @Spaces + @ColName + '}).'

        insert into @tbldataset
          select ''
     end
end

close csr
deallocate csr

select *
from  @tbldataset

return

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

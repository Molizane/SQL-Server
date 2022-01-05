set nocount on

declare @tbldataset table
(
  row varchar(200)
)

declare @tbtabelas table
(
  nome varchar(50)
)

insert into @tbtabelas select 'MovimentoSHF'
insert into @tbtabelas select 'MovSHFTeletrabalho'
insert into @tbtabelas select 'MovSHFTeletrabalhoHist'

insert into @tbldataset
  select '-module(shfdm).'

insert into @tbldataset
  select '-export([init/0, insert_emp/3, mk_projs/2]).'

insert into @tbldataset
  select ''

insert into @tbldataset
  select '-include("kittx.hrl").'

insert into @tbldataset
  select ''

insert into @tbldataset
  select 'init() ->'

declare
  @TableName sysname      = '',
  @row       varchar(200) = ''

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

  if @row <> ''
     insert into @tbldataset
       select @row + ','

  set @row = '    mnesia:create_table(' + @TableName + ', [{type, bag}, {attributes, record_info(fields, ' + @TableName + ')}])'
end

close csr

if @row <> ''
   insert into @tbldataset
     select @row + '.'

insert into @tbldataset
  select ''

--open csr

--while 1 = 1
--begin
--  fetch next
--  from csr
--  into @TableName

--  if @@fetch_status <> 0
--    break

--  insert into @tbldataset
--    select '% ' + @TableName
--  insert into @tbldataset
--    select 'insert_' + @TableName  + '(Reg) ->'
--  insert into @tbldataset
--    select '    Fun = fun() ->'
--  insert into @tbldataset
--    select '              mnesia:write(Reg)'
--  insert into @tbldataset
--    select '          end,'
--  insert into @tbldataset
--    select '    mnesia:transaction(Fun).'

--  insert into @tbldataset
--    select ''
--end

--close csr
--deallocate csr

  insert into @tbldataset
    select '% insert'
  insert into @tbldataset
    select 'insert(Reg) ->'
  insert into @tbldataset
    select '    Fun = fun() ->'
  insert into @tbldataset
    select '              mnesia:write(Reg)'
  insert into @tbldataset
    select '          end,'
  insert into @tbldataset
    select '    mnesia:transaction(Fun).'

select *
from  @tbldataset

return

declare RowsCsr cursor fast_forward for
  select *
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

select distinct
       --case b.xtype when 'P' then 'procedure' when 'FN' then 'function' else b.xtype end +
       --' dbo.' +
       b.name as nome
       --,a.text
from syscomments a, sysobjects b
where b.id = a.id
   and lower(a.text) like lower('%etc%')
order by nome

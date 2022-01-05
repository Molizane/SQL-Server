SELECT OBJECT_NAME (a.id) tablename,
       COUNT (1) nr_columns,
	   SUM (length) maxrowlength
FROM syscolumns a, sysobjects b
WHERE a.id=b.id and b.xtype='U'
GROUP BY OBJECT_NAME (a.id)
ORDER BY OBJECT_NAME (a.id)

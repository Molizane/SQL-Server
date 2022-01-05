SELECT OBJECT_NAME(i.object_id) "table", i.name AS index_name
	,i2.xmaxlen
    ,i.type_desc
    ,is_unique
    ,ds.type_desc AS filegroup_or_partition_scheme
    ,ds.name AS filegroup_or_partition_scheme_name
    ,ignore_dup_key
    ,is_primary_key
    ,is_unique_constraint
    ,fill_factor
    ,is_padded
    ,is_disabled
    ,allow_row_locks
    ,allow_page_locks
FROM sys.indexes AS i
INNER JOIN sys.data_spaces AS ds ON i.data_space_id = ds.data_space_id
INNER JOIN sysobjects AS b ON i.object_id = b.id
INNER JOIN sysindexes i2 on i2.id = i.object_id and i2.indid=1 and i2.status <> 18
WHERE is_hypothetical = 0 AND i.index_id <> 0 
--AND i.object_id = OBJECT_ID('Production.Product');
AND   b.xtype='U'
ORDER BY OBJECT_NAME(i.object_id), i.name
GO

SET NOCOUNT ON

DECLARE
  @TableName sysname = 'MovimentoSHF',
  @prop VARCHAR(MAX)

PRINT 'Public Class ' + @TableName -- + CHAR(13) + CHAR(10) + ' '

DECLARE props CURSOR FAST_FORWARD FOR
SELECT DISTINCT ' public property ' + ColumnName + ' AS ' + ColumnType + /*CHAR(13) + CHAR(10) +*/ ' ' AS prop
FROM (
      SELECT REPLACE(col.name, ' ', '_') ColumnName, column_id,
             CASE typ.name
                 WHEN 'bigint' THEN 'long'
                 WHEN 'binary' THEN 'byte[]'
                 WHEN 'bit' THEN 'boolean'
                 WHEN 'char' THEN 'string'
                 WHEN 'date' THEN 'DateTime'
                 WHEN 'datetime' THEN 'DateTime'
                 WHEN 'datetime2' THEN 'DateTime'
                 WHEN 'datetimeoffset' THEN 'DateTimeOffset'
                 WHEN 'decimal' THEN 'decimal'
                 WHEN 'float' THEN 'float'
                 WHEN 'image' THEN 'byte[]'
                 WHEN 'int' THEN 'integer'
                 WHEN 'money' THEN 'decimal'
                 WHEN 'nchar' THEN 'char'
                 WHEN 'ntext' THEN 'string'
                 WHEN 'numeric' THEN 'decimal'
                 WHEN 'nvarchar' THEN 'string'
                 WHEN 'real' THEN 'double'
                 WHEN 'smalldatetime' THEN 'DateTime'
                 WHEN 'smallint' THEN 'short'
                 WHEN 'smallmoney' THEN 'decimal'
                 WHEN 'text' THEN 'string'
                 WHEN 'time' THEN 'TimeSpan'
                 WHEN 'timestamp' THEN 'DateTime'
                 WHEN 'tinyint' THEN 'byte'
                 WHEN 'uniqueidentifier' THEN 'Guid'
                 WHEN 'varbinary' THEN 'byte[]'
                 WHEN 'varchar' THEN 'string'
             END ColumnType
      FROM sys.columns col 
      JOIN sys.types typ 
        ON col.system_type_id = typ.system_type_id
      WHERE object_id = object_id(@TableName)) t
ORDER BY prop

OPEN props

FETCH NEXT FROM props 
INTO @prop

WHILE @@FETCH_STATUS = 0
BEGIN
    print @prop
    FETCH NEXT FROM props 
    INTO @prop
END

CLOSE props
DEALLOCATE props

PRINT ''
PRINT 'End Class'
GO

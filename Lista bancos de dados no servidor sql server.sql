SELECT dtb.name AS [Database_Name],
       'Server[@Name=' + quotename(CAST(serverproperty(N'Servername')AS sysname),'''') + ']' + '/Database[@Name=' + quotename(dtb.name,'''') + ']' AS [Database_Urn],
       dtb.recovery_model AS [Database_RecoveryModel],
       ISNULL(suser_sname(dtb.owner_sid),'') AS [Database_Owner],
       case when dtb.collation_name is null then 0x200 else 0 end |
       case when 1 = dtb.is_in_standby then 0x40 else 0 end |
       case dtb.state 
            when 1 then 0x2 
            when 2 then 0x8 
            when 3 then 0x4
            when 4 then 0x10
            when 5 then 0x100
            when 6 then 0x20
            else 1
       end AS [Database_Status],
       dtb.compatibility_level AS [Database_CompatibilityLevel],
       ISNULL(dmi.mirroring_role,0) AS [Database_MirroringRole],
       ISNULL(dmi.mirroring_state + 1, 0) AS [Database_MirroringStatus],
       CAST(case when SERVERPROPERTY('EngineEdition') = 6 
                 then cast(1 as bit)
                  else cast(0 as bit)
             end AS bit) AS [Database_IsSqlDw],
       dtb.recovery_model AS [RecoveryModel],
       dtb.user_access AS [UserAccess],
       dtb.is_read_only AS [ReadOnly],
       dtb.name AS [Database_DatabaseName2]
FROM master.sys.databases AS dtb
LEFT OUTER JOIN sys.database_mirroring AS dmi ON dmi.database_id = dtb.database_id
WHERE (CAST(case when dtb.name in ('master','model','msdb','tempdb') then 1 else dtb.is_distributor end AS bit) = 0 
  and CAST(isnull(dtb.source_database_id, 0) AS bit) = 0)
ORDER BY [Database_Name] ASC

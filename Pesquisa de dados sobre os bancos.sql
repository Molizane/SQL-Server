--[2019-05-21T14:14:24.0618496-03:00 Begin Query] URN:Server/Information
--[2019-05-21T14:14:24.0774754-03:00 End Query] URN:Server/Information 

--Elapsed time:7,0459 ms 

--Query: 
SELECT CAST( serverproperty(N'Servername') AS sysname) AS [Server_Name],
       'Server[@Name=' + quotename(CAST(serverproperty(N'Servername') AS sysname),'''') + ']' AS [Server_Urn],
       CAST(null AS int) AS [Server_ServerType],
       CAST(0x0001 AS int) AS [Server_Status],
       0 AS [Server_IsContainedAuthentication],
       (@@microsoftversion / 0x1000000) & 0xff AS [VersionMajor],
       (@@microsoftversion / 0x10000) & 0xff AS [VersionMinor],
       @@microsoftversion & 0xffff AS [BuildNumber],
       CAST(SERVERPROPERTY('IsSingleUser') AS bit) AS [IsSingleUser],
       CAST(SERVERPROPERTY(N'Edition') AS sysname) AS [Edition],
       CAST(SERVERPROPERTY('EngineEdition') AS int) AS [EngineEdition],
       CAST(ISNULL(SERVERPROPERTY(N'IsXTPSupported'), 0) AS bit) AS [IsXTPSupported],
       SERVERPROPERTY(N'ProductVersion') AS [VersionString],
       N'Windows' AS [HostPlatform],
       CAST(FULLTEXTSERVICEPROPERTY('IsFullTextInstalled') AS bit) AS [IsFullTextInstalled]
ORDER BY [Server_Name] ASC


--[2019-05-21T14:14:24.7337903-03:00 Begin Query] URN:Server[@Name='SRV911']/JobServer
--[2019-05-21T14:14:24.7337903-03:00 End Query] URN:Server[@Name='SRV911']/JobServer 

--Elapsed time:1,4001 ms 

--Query: 
SELECT CAST(serverproperty(N'Servername') AS sysname) AS [Name],
       'Server[@Name=' + quotename(CAST(serverproperty(N'Servername') AS sysname),'''') + ']' + '/JobServer' AS [Urn]
ORDER BY [Name] ASC


--[2019-05-21T14:15:34.2406398-03:00 Begin Query] URN:Server[@Name='SRV911']/Database[@IsSystemObject = 0 and @IsDatabaseSnapshot = 0]/Option
--[2019-05-21T14:15:34.3190115-03:00 End Query] URN:Server[@Name='SRV911']/Database[@IsSystemObject = 0 and @IsDatabaseSnapshot = 0]/Option 

--Elapsed time:80,3802 ms 

--Query: 
SELECT dtb.name AS [Database_Name],
       'Server[@Name=' + quotename(CAST(serverproperty(N'Servername') AS sysname),'''') + ']' + '/Database[@Name=' + quotename(dtb.name,'''') + ']' AS [Database_Urn],
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
WHERE (CAST(case when dtb.name in ('master','model','msdb','tempdb') then 1 else dtb.is_distributor end AS bit)=0 and CAST(isnull(dtb.source_database_id, 0) AS bit)=0)
ORDER BY [Database_Name] ASC


--[2019-05-21T14:17:47.9108099-03:00 Begin Query] URN:Server[@Name='SRV911']/Database[@Name='DB_Atendimento']/Option
--[2019-05-21T14:17:47.9423070-03:00 End Query] URN:Server[@Name='SRV911']/Database[@Name='DB_Atendimento']/Option 

--Elapsed time:24,2622 ms 

--Query: 
SELECT dtb.name AS [Database_Name],
       'Server[@Name=' + quotename(CAST(serverproperty(N'Servername') AS sysname),'''') + ']' + '/Database[@Name=' + quotename(dtb.name,'''') + ']' AS [Database_Urn],
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
WHERE (dtb.name='DB_Atendimento')
ORDER BY
[Database_Name] ASC


--[2019-05-21T14:30:37.6751538-03:00 Begin Query] URN:Server[@Name='SRV911']/Database[@Name='DB_WSCalculo']/User
--[2019-05-21T14:30:37.8160356-03:00 End Query] URN:Server[@Name='SRV911']/Database[@Name='DB_WSCalculo']/User 

--Elapsed time:142,9697 ms 

--Query: 
SELECT u.name AS [Name],
       'Server[@Name=' + quotename(CAST(serverproperty(N'Servername') AS sysname),'''') + ']' + '/Database[@Name=' + quotename(db_name(),'''') + ']' + '/User[@Name=' + quotename(u.name,'''') + ']' AS [Urn],
       u.create_date AS [CreateDate],
       u.principal_id AS [ID],
       CAST(CASE dp.state WHEN N'G' THEN 1 WHEN 'W' THEN 1 ELSE 0 END AS bit) AS [HasDBAccess]
FROM sys.database_principals AS u
LEFT OUTER JOIN sys.database_permissions AS dp ON dp.grantee_principal_id = u.principal_id and dp.type = 'CO'
WHERE (u.type in ('U', 'S', 'G', 'C', 'K' ,'E', 'X'))
ORDER BY [Name] ASC


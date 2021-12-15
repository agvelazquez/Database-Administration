select 
 o.name as objectname
,ix.name as indexname
,ixu.user_seeks + ixu.user_scans + ixu.user_lookups as user_reads
,ixu.user_updates as user_writes
,sum(p.rows) as total_rows
from sys.dm_db_index_usage_stats ixu
inner join sys.indexes ix 
	on ixu.object_id = ix.object_id
	and ixu.index_id = ix.index_id
inner join sys.partitions p 
	on ixu.object_id = p.object_id
	and ixu.index_id = p.index_id
inner join sys.objects o
	on ixu.object_id = o.object_id
where
	ixu.database_id = DB_ID()
	and OBJECTPROPERTY(ixu.object_id, 'IsUserTable') = 1
	and ixu.index_id > 0 
group by 
	o.name	
	,ix.name
	,ixu.user_seeks + ixu.user_scans + ixu.user_lookups
	,ixu.user_updates
having 
	 ixu.user_seeks + ixu.user_scans + ixu.user_lookups = 0
order by 
	ixu.user_updates desc
	,o.name
	,ix.name

-- index usage 
select 
     OBJECT_NAME(ixu.object_id) as object_name
	,ix.name
	,user_scans + user_seeks + user_lookups as user_reads
	,user_updates as user_writes
from sys.dm_db_index_usage_stats ixu
inner join sys.indexes ix 
		on	ixu.object_id = ix.object_id 
			and ixu.index_id = ix.index_id
			and database_id = DB_ID()
where database_id = DB_ID()
order by 3 desc


-- unused indexes 
select 
OBJECT_NAME(ix.object_id) as objectname
,ix.name
from sys.indexes as ix
inner join sys.objects o 
	on ix.object_id = o.object_id
where ix.index_id not in (
		select ixu.index_id
		from sys.dm_db_index_usage_stats as ixu
		where 
			ixu.object_id = ix.object_id 
			and ixu.index_id = ix.index_id
			and database_id = DB_ID()
			)
and  o.type = 'U'
order by OBJECT_NAME(ix.object_id) asc;

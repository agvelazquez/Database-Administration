-- Missing indexes suggested by the query optimizer when the TSQL statement is compiled by the order of improvement

select 
 (user_seeks + user_scans) * avg_total_user_cost * (avg_user_impact * 0.01) as IndexImprovement
,id.statement
,id.equality_columns
,id.inequality_columns  -- columns useful for queries that include the <> operator
,id.included_columns --suggested columns in the include statement
from sys.dm_db_missing_index_group_stats igs 
inner join sys.dm_db_missing_index_groups ig
	on igs.group_handle = ig.index_group_handle
inner join sys.dm_db_missing_index_details id
	on ig.index_handle = id.index_handle
order by IndexImprovement desc

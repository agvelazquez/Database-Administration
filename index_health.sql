DECLARE @db_id SMALLINT, @object_ID INT;

SET @db_id = DB_ID(N'WideWorldImportersDW') -- set your current DB
SET @object_ID = OBJECT_ID(N'WideWorldImportersDW.Fact.Transaction') -- set the target table

SELECT 
	ixs.index_id
	,ix.name
	,index_type_desc
	,page_count
	,avg_page_space_used_in_percent
	,fragment_count
	,avg_fragmentation_in_percent
from sys.dm_db_index_physical_stats (@db_id, @object_ID, NULL, NULL, 'Detailed') ixs
INNER JOIN sys.indexes ix 
	on ixs.index_id = ix.index_id
	and ixs.object_id = ix.object_id
ORDER BY avg_fragmentation_in_percent DESC

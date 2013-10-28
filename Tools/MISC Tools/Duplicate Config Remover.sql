/* This procedure is for removing duplicate configurable products from Magento. */

-- Drop all temp tables that get created later on so that the procedure can be run back-to-back
IF OBJECT_ID('tempdb..#duplicate_configs') IS NOT NULL BEGIN
	DROP TABLE #duplicate_configs
END	
	
IF OBJECT_ID('tempdb..#configs_reference') IS NOT NULL BEGIN
	DROP TABLE #configs_reference
END

IF OBJECT_ID('tempdb..#associated_products') IS NOT NULL BEGIN
	DROP TABLE #associated_products
END	

IF OBJECT_ID('tbl_Related_Products') IS NOT NULL BEGIN
	DROP TABLE tbl_Related_Products
END	

IF OBJECT_ID('tempdb..#oldest_configs') IS NOT NULL BEGIN
	DROP TABLE #oldest_configs
END

IF OBJECT_ID('tempdb..#middle_configs') IS NOT NULL BEGIN
	DROP TABLE #middle_configs
END	

IF OBJECT_ID('tempdb..#newest_configs') IS NOT NULL BEGIN
	DROP TABLE #newest_configs
END	

IF OBJECT_ID('tempdb..#new_simples') IS NOT NULL BEGIN
	DROP TABLE #new_simples
END	

IF OBJECT_ID('tempdb..#old_simples') IS NOT NULL BEGIN
	DROP TABLE #old_simples
END	

IF OBJECT_ID('tempdb..#combined_simples') IS NOT NULL BEGIN
	DROP TABLE #combined_simples
END	

/* This SELECT returns each DISTINCT name + department combination from Magento where 
there are two or more configurable skus having said name + department combination */
SELECT * INTO #duplicate_configs FROM OPENQUERY(MAGENTO,'
SELECT b.value AS name, c.value AS department, COUNT(a.sku) AS num_skus
FROM catalog_product_entity AS a
INNER JOIN catalog_product_entity_varchar AS b
ON a.entity_id = b.entity_id AND b.attribute_id = (SELECT attribute_id FROM eav_attribute WHERE entity_type_id = 4 AND attribute_code = ''name'')
INNER JOIN 
	(SELECT a.entity_id, b.value 
	FROM catalog_product_entity_varchar AS a
	INNER JOIN eav_attribute_option_value AS b
	ON a.value = b.option_id AND b.store_id = 0 AND a.attribute_id = (SELECT attribute_id FROM eav_attribute WHERE entity_type_id = 4 AND attribute_code = ''department'')) AS c
ON a.entity_id = c.entity_id   
WHERE a.type_id = ''configurable'' AND a.created_at > (CURDATE() - 30)
GROUP BY b.value, c.value
HAVING COUNT(a.sku) = 2')

/* This SELECT returns information about each configurable product from Magento regardless of whether it has a duplicate Name + Department combination */
SELECT * INTO #configs_reference FROM OPENQUERY(MAGENTO,'
SELECT DISTINCT b.value AS name, c.value AS department, a.sku, a.entity_id, a.created_at
FROM catalog_product_entity AS a
INNER JOIN catalog_product_entity_varchar AS b
ON a.entity_id = b.entity_id AND b.attribute_id = (SELECT attribute_id FROM eav_attribute WHERE entity_type_id = 4 AND attribute_code = ''name'')
INNER JOIN 
	(SELECT a.entity_id, b.value 
	FROM catalog_product_entity_varchar AS a
	INNER JOIN eav_attribute_option_value AS b
	ON a.value = b.option_id AND b.store_id = 0 AND a.attribute_id = (SELECT attribute_id FROM eav_attribute WHERE entity_type_id = 4 AND attribute_code = ''department'')) AS c
ON a.entity_id = c.entity_id   
WHERE a.type_id = ''configurable'' AND a.created_at > (CURDATE() - 30)')

-- Here I replicate catalog_product_super_link as a temp table for optimization purposes and in order to avoid querying the live DB
SELECT * INTO #associated_products FROM OPENQUERY(MAGENTO,'SELECT * FROM catalog_product_super_link')

-- This select populates a temp table, identifying all of the configurable products that are duplicates, and the simple products associated to them
SELECT related_products.* INTO tbl_Related_Products FROM 
	(SELECT DISTINCT a.name, a.sku, a.created_at, CAST(a.entity_id AS nvarchar(255)) AS entity_id, CAST(c.product_id AS nvarchar(255)) AS simples 
	FROM #configs_reference AS a
	INNER JOIN #duplicate_configs AS b
	ON a.name = b.name AND a.department = b.department
	INNER JOIN #associated_products AS c
	ON a.entity_id = c.parent_id) AS related_products

/* This select extracts all of the rows from the temp table created in the previous select for the OLDER of each 
set of duplicate configurable products */
SELECT oldest_configs.* INTO #oldest_configs FROM 
	(SELECT a.name, MIN(a.created_at) AS oldest_created_at
	FROM #configs_reference AS a
	INNER JOIN #duplicate_configs AS b
	ON a.name = b.name AND a.department = b.department
	INNER JOIN #associated_products AS c
	ON a.entity_id = c.parent_id
	GROUP BY a.name) AS oldest_configs
/*	
/* This select extracts all of the rows from the temp table created in the previous select for the MIDDLE of each 
set of duplicate configurable products */ 
SELECT middle_configs.* INTO #middle_configs FROM 
	(SELECT a.name, a.created_at AS middle_created_at
	FROM #configs_reference AS a
	INNER JOIN #duplicate_configs AS b
	ON a.name = b.name AND a.department = b.department
	INNER JOIN #associated_products AS c
	ON a.entity_id = c.parent_id
	INNER JOIN (SELECT name, MAX(created_at) AS max_date, MIN(created_at) AS min_date FROM #configs_reference GROUP BY name) AS d
	ON a.name = d.name
	WHERE a.created_at <> d.max_date AND a.created_at <> d.min_date
	) AS middle_configs */

/* This select extracts all of the rows from the temp table created in the previous select for the NEWER of each 
set of duplicate configurable products */
SELECT newest_configs.* INTO #newest_configs FROM 
	(SELECT a.name, MAX(a.created_at) AS newest_created_at
	FROM #configs_reference AS a
	INNER JOIN #duplicate_configs AS b
	ON a.name = b.name AND a.department = b.department
	INNER JOIN #associated_products AS c
	ON a.entity_id = c.parent_id
	GROUP BY a.name) AS newest_configs

/* Here I begin making new temp tables for each record set: OLDER, MIDDLE (if applicable) & NEWER, concatenating the simple product
 rows from the previous record sets into the simples_skus column so as to have only one row per configurable product */
CREATE TABLE #new_simples (name nvarchar(255), sku nvarchar(255), simples_skus nvarchar(MAX))

INSERT INTO #new_simples (name, sku, simples_skus)
	SELECT DISTINCT a.name, b.sku, dbo.getAssociatedProducts(b.entity_id)
	FROM #newest_configs AS a
	INNER JOIN tbl_Related_Products AS b
	ON a.name = b.name AND a.newest_created_at = b.created_at
/*	
CREATE TABLE #middle_simples (name nvarchar(255), sku nvarchar(255), simples_skus nvarchar(MAX))

INSERT INTO #middle_simples (name, sku, simples_skus)
	SELECT DISTINCT a.name, b.sku, dbo.getAssociatedProducts(b.entity_id)
	FROM #middle_configs AS a
	INNER JOIN tbl_Related_Products AS b
	ON a.name = b.name AND a.middle_created_at = b.created_at */
	
CREATE TABLE #old_simples (name nvarchar(255), sku nvarchar(255), simples_skus nvarchar(MAX))

INSERT INTO #old_simples (name, sku, simples_skus)
	SELECT DISTINCT a.name, b.sku, dbo.getAssociatedProducts(b.entity_id)
	FROM #oldest_configs AS a
	INNER JOIN tbl_Related_Products AS b
	ON a.name = b.name AND a.oldest_created_at = b.created_at

/* Now create a new table with the same schema as the previous two temp table, and initially populate
 it with the data from the NEWER configurable product record set */
CREATE TABLE #combined_simples (name nvarchar(255), sku nvarchar(255), simples_skus nvarchar(MAX))

INSERT INTO #combined_simples (name, sku, simples_skus)
	SELECT name, sku, simples_skus
	FROM #new_simples
	
/* Now perform a correlated update to concatenate the simples_skus value for both the 
OLDER & NEWER configurable products into the simples_skus value for the NEWER configurable sku. During the concatenation,
perform some simple manipulations in order to prepare the simples_skus string value for use in a dynamic SQL statement in the next step */
UPDATE a SET
	a.simples_skus = '''' + REPLACE(a.simples_skus + ',' + b.simples_skus/* + ',' + c.simples_skus*/,',',''''',''''') + ''''
FROM #combined_simples AS a
INNER JOIN #old_simples AS b
ON a.name = b.name
--INNER JOIN #middle_simples AS c
--ON a.name = c.name

/* Using a CURSOR, iterate through the list of NEWER configurable skus, and replace the entity_id values under the 
simples_skus column with the corresponding sku values from Magento in order to allow import via MAGMI */
DECLARE @name nvarchar(255), @simples_skus nvarchar(MAX), @sql nvarchar(MAX)

DECLARE update_simples_skus CURSOR FOR
SELECT DISTINCT name, simples_skus FROM #combined_simples
 
OPEN update_simples_skus

FETCH NEXT FROM update_simples_skus INTO @name, @simples_skus
 
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @sql = '
	UPDATE #combined_simples SET simples_skus =
		(SELECT simples_skus FROM OPENQUERY(MAGENTO,''
			SELECT simples_skus FROM (
			SELECT GROUP_CONCAT(sku) AS simples_skus 
			FROM catalog_product_entity 
			WHERE entity_id IN(''' + @simples_skus + ''')) AS x
			''))
	WHERE name = ''' + @name + '''
	'
	EXEC (@sql)	
	FETCH NEXT FROM update_simples_skus INTO @name, @simples_skus
END
 
CLOSE update_simples_skus
DEALLOCATE update_simples_skus
GO

/* Perform two simple SELECT statements, preparing the final data for the following actions:
	1. Update the simples_skus attribute for the NEWER configurable to associated it with ALL of the simple products from BOTH configurables 
	2. Delete the OLDER configurable products from Magento
*/
SELECT 'configurable' AS type, sku, '1' AS has_options, '"choose_color,choose_size"' AS configurable_attributes, '"' + simples_skus + '"' AS simples_skus 
FROM #combined_simples

SELECT '1' AS 'magmi:delete', sku
FROM #old_simples
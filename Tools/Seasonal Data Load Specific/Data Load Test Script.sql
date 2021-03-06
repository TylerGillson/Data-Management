DECLARE @output varchar(MAX), @count nvarchar(MAX)

PRINT 'PAT'

-- Multiple Price/Cost test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + x.error FROM
(SELECT DISTINCT name + ' (' + MAX(vendor_product_id) + ')' AS error
 FROM tbl_LoadFile_SS14_COL
 WHERE type = 'configurable'
 GROUP BY name, department, price, cost
 HAVING (COUNT(price) + COUNT(cost)) > 2) AS x

SET @count = (SELECT SUM(x.total) FROM
			  (SELECT name, CASE WHEN (COUNT(price) + COUNT(cost)) > 2 THEN 1 ELSE 0 END AS total
			  FROM tbl_LoadFile_SS14_COL 
			  WHERE type = 'configurable'
			  GROUP BY name, department, price, cost) AS x)

IF @count <> 0 BEGIN
	PRINT 'Failed Multiple Price/Cost test'
	PRINT '	There are ' + @count + ' styles with more than one price or more than one cost:'
	PRINT '		' + @output
	SET @output = ''
END
ELSE BEGIN
	PRINT 'Passed Multiple Price/Cost test'
END
SET @output = NULL

-- Price/Cost test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + vendor_product_id FROM
(SELECT DISTINCT vendor_product_id FROM tbl_LoadFile_SS14_COL WHERE type = 'configurable' AND CAST(price AS float) <= 0 OR price IS NULL OR cost IS NULL) AS x

SET @count = (SELECT COUNT(DISTINCT vendor_product_id) FROM tbl_LoadFile_SS14_COL WHERE type = 'configurable' AND CAST(price AS float) <= 0 OR price IS NULL OR cost IS NULL)

IF @count <> 0 BEGIN
	PRINT 'Failed Price/Cost test'
	PRINT '	There are ' + @count + ' styles missing a price or a cost:'
	PRINT '		' + @output
	SET @output = ''
END
ELSE BEGIN
	PRINT 'Passed Price/Cost test'
END
SET @output = NULL

-- Duplicate Configurables Test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + name FROM
(SELECT name
 FROM (SELECT name + ' (' + department + ')' AS name, COUNT(*) AS total FROM tbl_LoadFile_SS14_COL WHERE type = 'configurable' GROUP BY name + ' (' + department + ')') AS a WHERE a.total > 1) AS x
 
IF @output <> '' BEGIN
	PRINT 'Failed Duplicate Configurables Test'
	PRINT '	These configurable products are duplicates:'
	PRINT '		' + @output
	SET @output = ''
END
ELSE BEGIN
	PRINT 'Passed Duplicate Configurables Test'
END

-- One-off Simples test (Single row for a color-way on UPC list)
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + name FROM
(SELECT vendor_product_id + ' (' + name + ' - ' + vendor_color_code + ')' AS name FROM tbl_LoadFile_SS14_COL
			  WHERE type = 'simple' AND vendor_size_code <> 'O/S'
			  GROUP BY name, vendor_product_id, vendor_color_code
			  HAVING COUNT(*) = 1) AS x
			  
SET @count = (SELECT COUNT(*) FROM (SELECT name, vendor_product_id, vendor_color_code
			 FROM tbl_LoadFile_SS14_COL
			 WHERE type = 'simple' AND vendor_size_code <> 'O/S'
			 GROUP BY name, vendor_product_id, vendor_color_code
			 HAVING COUNT(*) = 1) AS y)

IF @count <> 0 BEGIN
	PRINT 'Failed One-off skus test'
	PRINT '	There are ' + @count + ' one-off skus:'
	PRINT '		' + @output
	SET @output = ''
END
ELSE BEGIN
	PRINT 'Passed One-off skus test'
END
SET @output = NULL

-- Duplicate SKUs test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + sku /*+ ' ' + vendor_sku*/ FROM
(SELECT sku
 FROM (SELECT sku, COUNT(*) AS total FROM tbl_LoadFile_SS14_COL GROUP BY sku HAVING MAX(type) = 'simple') AS a WHERE a.total > 1) AS x
 
IF @output <> '' BEGIN
	PRINT 'Failed Duplicate SKUs test'
	PRINT '	These SKUs are duplicates:'
	PRINT '		' + @output
	SET @output = ''
END
ELSE BEGIN
	PRINT 'Passed Duplicate SKUs test'
END

-- Associated Simple/Configurables test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + sku FROM
(SELECT a.sku AS sku FROM tbl_LoadFile_SS14_COL AS a LEFT JOIN tbl_LoadFile_SS14_COL AS b
 ON b.type = 'configurable' AND b.simples_skus LIKE '%' + a.sku + '%'
 WHERE a.type = 'simple' AND b.sku IS NULL) AS x
 
IF @output <> '' BEGIN
	PRINT 'Failed Associated Simple/Configurables test'
	PRINT '	These SKUs are not associated to configurables:'
	PRINT '		' + @output
	SET @output = ''
END
ELSE BEGIN
	PRINT 'Passed Associated Simple/Configurables test'
END

-- Features test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + name FROM
(SELECT name + ' (' + vendor_product_id + ')' AS name FROM tbl_LoadFile_SS14_COL WHERE type = 'configurable' AND (features IS NULL OR features = '')) AS x

SET @count = (SELECT COUNT(*) FROM tbl_LoadFile_SS14_COL WHERE type = 'configurable' AND (features IS NULL OR features = ''))

IF @count <> 0 BEGIN
	PRINT 'Failed Features test'
	PRINT '	There are ' + @count + ' styles missing features:'
	PRINT '		' + @output
	SET @output = ''
END
ELSE BEGIN
	PRINT 'Passed Features test'
END
SET @output = NULL

-- Fabric test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + name FROM
(SELECT name + ' (' + vendor_product_id + ')' AS name FROM tbl_LoadFile_SS14_COL WHERE type = 'configurable' AND (fabric IS NULL OR fabric = '')) AS x

SET @count = (SELECT COUNT(*) FROM tbl_LoadFile_SS14_COL WHERE type = 'configurable' AND (fabric IS NULL OR fabric = ''))

IF @count <> 0 BEGIN
	PRINT 'Failed Fabric test'
	PRINT '	There are ' + @count + ' styles missing a fabric value:'
	PRINT '		' + @output
	SET @output = ''
END
ELSE BEGIN
	PRINT 'Passed Fabric test'
END
SET @output = NULL

-- Descriptions test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + name FROM
(SELECT name + ' (' + vendor_product_id + ')' AS name FROM tbl_LoadFile_SS14_COL WHERE type = 'configurable' AND (description IS NULL OR description = '')) AS x

SET @count = (SELECT COUNT(*) FROM tbl_LoadFile_SS14_COL WHERE type = 'configurable' AND (description IS NULL OR description = ''))

IF @count <> 0 BEGIN
	PRINT 'Failed Descriptions test'
	PRINT '	There are ' + @count + ' styles missing a description:'
	PRINT '		' + @output
	SET @output = ''
END
ELSE BEGIN
	PRINT 'Passed Descriptions test'
END
SET @output = NULL

-- Simples Without Photos test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + name FROM
(SELECT DISTINCT vendor_product_id + '-' + vendor_color_code  + ' (' + choose_color + ')' AS name FROM tbl_LoadFile_SS14_COL WHERE type = 'simple' AND (image = '' OR image IS NULL)) AS x

SET @count = (SELECT COUNT(DISTINCT vendor_product_id + ' ' + choose_color) FROM tbl_LoadFile_SS14_COL WHERE type = 'simple' AND (image = '' OR image IS NULL))
IF @count <> 0 BEGIN
	PRINT 'Failed Simples Without Photos test'
	PRINT '	There are ' + @count + ' simple products that don''t have images:'
	PRINT '		' + @output
	SET @output = ''
END
ELSE BEGIN
	PRINT 'Passed Simples Without Photos test'
END
SET @output = NULL

-- Categories test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + name FROM
(SELECT name FROM tbl_LoadFile_SS14_COL WHERE type = 'configurable' AND categories IS NULL OR categories = 'Uncategorized') AS x

SET @count = (SELECT COUNT(*) FROM tbl_LoadFile_SS14_COL WHERE type = 'configurable' AND categories IS NULL OR categories = 'Uncategorized')

IF @count <> 0 BEGIN
	PRINT 'Failed Categories test'
	PRINT '	There are ' + @count + ' styles missing categories:'
	PRINT '		' + @output
END
ELSE BEGIN
	PRINT 'Passed Categories test'
END
SET @output = NULL
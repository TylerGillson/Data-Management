/**
 * @category LiveOutThere.com
 * @package ETL/Merrell
 * @author Drew Gillson <drew@liveoutthere.com>
**/

USE LOT_Inventory

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tbl_RawData_S12_MER_Additional]')
AND OBJECTPROPERTY(id, N'IsUserTable') = 1) BEGIN
	CREATE TABLE [dbo].[tbl_RawData_S12_MER_Additional](
		ProductName [nvarchar](1024) NULL,
		SKU [nvarchar](1024) NULL,
		EnglishColor [nvarchar](1024) NULL,
		FrenchColor [nvarchar](1024) NULL,
		ShortDescription [nvarchar](1024) NULL,
		SizeRun [nvarchar](1024) NULL,
		WHSPrice [nvarchar](1024) NULL,
		MSRP [nvarchar](1024) NULL,
		EnglishDescription [nvarchar](MAX) NULL,
		FrenchDescription [nvarchar](MAX) NULL
	) ON [PRIMARY]

	TRUNCATE TABLE [dbo].[tbl_RawData_S12_MER_Additional]

	INSERT INTO [dbo].[tbl_RawData_S12_MER_Additional]
	SELECT * FROM OPENDATASOURCE( 'Microsoft.ACE.OLEDB.12.0', 'Data Source="C:\Data\Shared\ExcelSourceFiles\S12MerrellApparel.xlsx"; Extended properties=Excel 12.0')...Sheet1$
	WHERE [Price Analysis for Spring 2012] IS NOT NULL AND F9 IS NOT NULL

	UPDATE [dbo].[tbl_RawData_S12_MER_Additional] SET SKU = LEFT(SKU,8), EnglishColor = NULL, FrenchColor = NULL

	UPDATE [dbo].[tbl_RawData_S12_MER_Additional] SET EnglishDescription = LEFT(EnglishDescription, CHARINDEX('TECHNOLOGIE', EnglishDescription) - 1)
	WHERE (EnglishDescription LIKE '%TECHNOLOGIE%')
END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tbl_RawData_S12_MER]')
AND OBJECTPROPERTY(id, N'IsUserTable') = 1) BEGIN
	CREATE TABLE [dbo].[tbl_RawData_S12_MER](
		Brand [nvarchar](1024) NULL,
		Category [nvarchar](1024) NULL,
		[Grouping] [nvarchar](1024) NULL,
		Model [nvarchar](1024) NULL,
		Color [nvarchar](1024) NULL,
		Material [nvarchar](1024) NULL,
		Size [nvarchar](1024) NULL,
		Specs [nvarchar](1024) NULL,
		UPC [nvarchar](1024) NULL,
		Sizes [nvarchar](1024) NULL,
		Wholesale [nvarchar](1024) NULL,
		SRetail [nvarchar](1024) NULL,
		SizeNotes [nvarchar](1024) NULL
	) ON [PRIMARY]

	TRUNCATE TABLE [dbo].[tbl_RawData_S12_MER]

	INSERT INTO [dbo].[tbl_RawData_S12_MER]
	SELECT * FROM OPENDATASOURCE( 'Microsoft.ACE.OLEDB.12.0', 'Data Source="C:\Data\Shared\\ExcelSourceFiles\S12MerrellApparel.xlsx"; Extended properties=Excel 12.0')...matches$
	WHERE Brand IS NOT NULL

	UPDATE [dbo].[tbl_RawData_S12_MER] SET UPC = RIGHT(UPC,LEN(UPC)-1)
END

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tbl_RawData_S12_MER_Photos]')
AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[tbl_RawData_S12_MER_Photos] (
	[Filename] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Color] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Caption] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tbl_LoadFile_S12_MER]')
AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[tbl_LoadFile_S12_MER]

CREATE TABLE [dbo].[tbl_LoadFile_S12_MER](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[store] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_MER_store]  DEFAULT ('admin'),
	[websites] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_MER_websites]  DEFAULT ('base'),
	[type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sku] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[name] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[categories] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[attribute_set] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_MER_attribute_set]  DEFAULT ('default'),
	[configurable_attributes] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[has_options] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[price] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cost] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_MER_status]  DEFAULT ('Enabled'),
	[tax_class_id] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_MER_tax_class]  DEFAULT ('Taxable Goods'),
	[gender] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[visibility] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_MER_visibility]  DEFAULT ('Nowhere'),
	[image] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[image_label] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[small_image] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[thumbnail] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[media_gallery] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[choose_color] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[choose_size] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[vendor_sku] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[vendor_product_id] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[vendor_color_code] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[vendor_size_code] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[season] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_MER_season]  DEFAULT (N'Spring/Summer 2012'),
	[short_description] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[features] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activities] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[weather] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[layering] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[care_instructions] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fabric] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fit] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[volume] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[manufacturer] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_MER_manufacturer]  DEFAULT ('Merrell'),
	[qty] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_MER_qty]  DEFAULT ((10)),
	[is_in_stock] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_MER_is_in_stock]  DEFAULT ((1)),
	[simples_skus] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[url_key] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[super_attribute_pricing] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[videos] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[hs_tariff] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[origin] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[weight] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[us_skus] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cs_skus] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[xre_skus] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
 CONSTRAINT [PK_tbl_LoadFile_S12_MER] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_tbl_LoadFile_S12_MER] ON [dbo].[tbl_LoadFile_S12_MER] 
(
	[sku] ASC,
	[type] ASC,
	[vendor_product_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

UPDATE a SET
	a.Color = b.Color
FROM  tbl_RawData_S12_MER_Photos AS a
INNER JOIN  tbl_RawData_S12_MER AS b
ON a.Filename LIKE '%' + b.Material + '%'
WHERE a.Color IS NULL
GO

ALTER FUNCTION getMERGender (
	@Category varchar(50)
) RETURNS varchar(10)
AS
BEGIN
	DECLARE @output varchar(10)
	IF @Category LIKE '% Women''s%' BEGIN
		SET @output = 'Women'
	END
	ELSE IF @Category LIKE '% Men''s%' BEGIN
		SET @output = 'Men'
	END
	RETURN @output
END
GO

ALTER FUNCTION getMERDescription (
	@Style varchar(20), @Type varchar(20)
) RETURNS varchar(1024)
AS
BEGIN
	DECLARE @start int, @end int, @output varchar(1024)
	DECLARE @tbl Table (pn int, s nvarchar(1024), orig nvarchar(MAX))

	SET @output = ''
	
	INSERT INTO @tbl
	SELECT * FROM dbo.Split(CHAR(10), (SELECT EnglishDescription FROM tbl_RawData_S12_MER_Additional WHERE SKU = @Style))

	IF @Type = 'Features' BEGIN
		SELECT @start = pn FROM @tbl WHERE s LIKE '%FABRIC:%'
		SELECT @start = MIN(pn) FROM @tbl WHERE s = '' AND pn > @start
		SELECT @end = MIN(pn) FROM @tbl WHERE s = '' AND pn > @start
		(SELECT @output = COALESCE(@output + ' ', '') + s FROM
		(SELECT s FROM @tbl WHERE pn > @start AND pn <= @end) AS x)
		SET @output = REPLACE(@output, ' • ', '|') + '|'
	END
	ELSE IF @Type = 'Description' BEGIN
		(SELECT @output = COALESCE(@output + ' ', '') + s FROM
		(SELECT s FROM @tbl WHERE pn < (SELECT TOP 1 pn FROM @tbl WHERE s = '' ORDER BY pn)) AS x)
	END
	ELSE IF @Type = 'Fabric' BEGIN
		SELECT @start = pn FROM @tbl WHERE s LIKE '%FABRIC:%'
		SELECT @end = MIN(pn) - 1 FROM @tbl WHERE s = '' AND pn > @start
		(SELECT @output = COALESCE(@output + '|', '') + s FROM
		(SELECT s FROM @tbl WHERE pn > @start AND pn <= @end) AS x)
	END
	ELSE IF @Type = 'Technology' BEGIN
		SELECT @start = pn FROM @tbl WHERE s LIKE '%TECHNOLOGY:%'
		SELECT @end = MIN(pn) - 1 FROM @tbl WHERE s = '' AND pn > @start
		(SELECT @output = COALESCE(@output + '|', '') + s FROM
		(SELECT s FROM @tbl WHERE pn > @start AND pn <= @end) AS x)
	END
	ELSE IF @Type = 'Fit' BEGIN
		(SELECT @output = COALESCE(@output + ' ', '') + s FROM
		(SELECT s FROM @tbl WHERE s LIKE '%size%') AS x)
	END
	
	SET @output = dbo.toHTMLEntities(REPLACE(@output, '• ',''))
	
	IF LEFT(@output, 1) = '|' BEGIN
		SET @output = RIGHT(@output, LEN(@output) - 1)
	END
	
	RETURN LTRIM(RTRIM(@output))
	
END
GO

ALTER FUNCTION [dbo].[getMERMediaGallery] 
(
	@productid nvarchar(4000)
)
RETURNS nvarchar(4000)
AS
BEGIN
	DECLARE @output nvarchar(4000)
	
	(SELECT @output = COALESCE(@output + ';', '') + Photo FROM
	(SELECT DISTINCT image + CASE WHEN image_label IS NOT NULL THEN '::' + image_label ELSE '' END AS Photo FROM tbl_LoadFile_S12_MER WHERE type = 'simple' AND vendor_product_id = @productid AND image IS NOT NULL AND image <> (SELECT TOP 1 image FROM tbl_LoadFile_S12_MER WHERE type = 'configurable' AND vendor_product_id = @productid)) AS x)
	 	
	RETURN @output

END
GO

ALTER FUNCTION [dbo].[getMERAssociatedProducts] 
(
	@productid varchar(255)
)
RETURNS nvarchar(4000)
AS
BEGIN
	DECLARE @output nvarchar(4000)

	(SELECT @output = COALESCE(@output + ',', '') + sku FROM
	(SELECT sku AS sku
		FROM tbl_LoadFile_S12_MER WHERE (vendor_product_id = @productid) AND type = 'simple' AND image IS NOT NULL)
	 AS x)
	
	RETURN @output
END
GO

TRUNCATE TABLE tbl_LoadFile_S12_MER

INSERT INTO tbl_LoadFile_S12_MER (
		sku,
		vendor_product_id,
		[name],
		gender,
		choose_color,
		choose_size,
		vendor_color_code,
		vendor_size_code,
		vendor_sku,
		price,
		cost,
		has_options,
		[type],
		[image],
		image_label
)
SELECT DISTINCT
		dbo.getMagentoSimpleSKU('MER', LEFT(a.Material,8), RIGHT(a.Material,3), a.Size) AS sku,
		LEFT(a.Material,8) AS vendor_product_id,
		dbo.getMERGender(a.Category) + '''s ' + a.Model AS productname,
		dbo.getMERGender(a.Category) AS gender,
		dbo.ProperCase(REPLACE(a.Color,' C/O','')) AS choose_color,
		a.Size AS choose_size,
		RIGHT(a.Material,3) AS vendor_color_code,
		a.Size AS vendor_size_code,
		a.UPC AS vendor_sku,
		CAST(a.SRetail AS float) - 0.01 AS price,
		CAST(a.Wholesale AS float) AS cost,
		0 AS has_options,
		'simple' AS type,
		(SELECT TOP 1 Filename FROM tbl_RawData_S12_MER_Photos WHERE Filename LIKE '%' + a.Material + '%' ORDER BY Color DESC) AS image,
		(SELECT TOP 1 Color FROM tbl_RawData_S12_MER_Photos WHERE Filename LIKE '%' + a.Material + '%' ORDER BY Color DESC) AS image_label
FROM tbl_RawData_S12_MER AS a

INSERT INTO tbl_LoadFile_S12_MER (
	sku,
	configurable_attributes,
	vendor_product_id,
	categories,
	name,
	gender,
	price,
	cost,
	short_description,
	fabric,
	features,
	description,
	has_options,
	type,
	visibility,
	fit
)
SELECT DISTINCT
		dbo.getMagentoConfigurableSKU('MER', b.SKU) AS sku,
		'choose_color,choose_size' AS config_attributes,
		b.SKU AS model,
		'' AS categories,
		dbo.getMERGender(a.Category) + '''s ' + a.Model AS name,
		dbo.getMERGender(a.Category) AS gender,
		(SELECT MIN(price) FROM tbl_LoadFile_S12_MER WHERE vendor_product_id = b.SKU) AS price,
		(SELECT MIN(cost) FROM tbl_LoadFile_S12_MER WHERE vendor_product_id = b.SKU) AS cost,
		b.ShortDescription AS short_description,
		dbo.getMERDescription(b.SKU, 'Fabric') AS fabric,
		dbo.getMERDescription(b.SKU, 'Features') + dbo.getMERDescription(b.SKU, 'Technology') AS features,
		dbo.getMERDescription(b.SKU, 'Description') AS description,
		'1' AS has_options,
		'configurable' AS type,
		'Catalog, Search' AS visibility,
		dbo.getMERDescription(b.SKU, 'Fit') AS fit
FROM tbl_RawData_S12_MER AS a
LEFT OUTER JOIN tbl_RawData_S12_MER_Additional AS b ON LEFT(a.Material,8) = b.SKU

UPDATE a SET
	image = (SELECT TOP 1 image FROM tbl_LoadFile_S12_MER WHERE type = 'simple' AND vendor_product_id = a.vendor_product_id ORDER BY image_label DESC),
	image_label = (SELECT TOP 1 image_label FROM tbl_LoadFile_S12_MER WHERE type = 'simple' AND vendor_product_id = a.vendor_product_id ORDER BY image_label DESC),
	simples_skus = dbo.getMERAssociatedProducts(a.vendor_product_id)
FROM tbl_LoadFile_S12_MER AS a
WHERE type = 'configurable'

UPDATE a SET
	media_gallery = dbo.getMERMediaGallery(a.vendor_product_id)
FROM tbl_LoadFile_S12_MER AS a
WHERE type = 'configurable'

UPDATE tbl_LoadFile_S12_MER SET small_image = image, thumbnail = image WHERE image IS NOT NULL




/**
 * Almost done! Now we have to do some sanity checks and run some tests. The following routines all check
 * for data consistency and accuracy before we output to CSV and upload to Magento.
**/

DECLARE @output varchar(MAX), @count nvarchar(3)

-- Categories test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + name FROM
(SELECT name FROM tbl_LoadFile_S12_MER WHERE type = 'configurable' AND categories IS NULL) AS x

SET @count = (SELECT COUNT(*) FROM tbl_LoadFile_S12_MER WHERE type = 'configurable' AND categories IS NULL)

IF @count <> 0 BEGIN
	PRINT 'Failed Categories test'
	PRINT '	There are ' + @count + ' styles missing categories:'
	PRINT '		' + @output
END
ELSE BEGIN
	PRINT 'Passed Categories test'
END
SET @output = NULL

-- Duplicate SKUs test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + sku FROM
(SELECT DISTINCT sku FROM tbl_LoadFile_S12_MER AS a WHERE (SELECT COUNT(*) FROM tbl_LoadFile_S12_MER WHERE sku = a.sku) > 1) AS x

SET @count = (SELECT COUNT(DISTINCT sku) FROM tbl_LoadFile_S12_MER AS a WHERE (SELECT COUNT(*) FROM tbl_LoadFile_S12_MER WHERE sku = a.sku) > 1)

IF @count <> 0 BEGIN
	PRINT 'Failed Duplicate SKUs test'
	PRINT '	There are ' + @count + ' styles with duplicate SKUs:'
	PRINT '		' + @output
END
ELSE BEGIN
	PRINT 'Passed Duplicate SKUs test'
END
SET @output = NULL
	
-- Associated Simple/Configurables test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + sku FROM
(SELECT a.sku AS sku FROM tbl_LoadFile_S12_MER AS a LEFT JOIN tbl_LoadFile_S12_MER AS b
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

-- Configurable Images test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + name FROM
(SELECT name + ' (' + vendor_product_id + ')' AS name FROM tbl_LoadFile_S12_MER WHERE type = 'configurable' AND (image IS NULL or image_label IS NULL)) AS x

SET @count = (SELECT COUNT(*) FROM tbl_LoadFile_S12_MER WHERE type = 'configurable' AND (image IS NULL or image_label IS NULL))

IF @count <> 0 BEGIN
	PRINT 'Failed Configurable Images test'
	PRINT '	There are ' + @count + ' styles missing a default image or image label:'
	PRINT '		' + @output
END
ELSE BEGIN
	PRINT 'Passed Configurable Images test'
END
SET @output = NULL

-- Prices test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + vendor_product_id FROM
(SELECT vendor_product_id FROM tbl_LoadFile_S12_MER WHERE CAST(price AS float) <= 0 OR price IS NULL) AS x

SET @count = (SELECT COUNT(*) FROM tbl_LoadFile_S12_MER WHERE CAST(price AS float) <= 0 OR price IS NULL)

IF @count <> 0 BEGIN
	PRINT 'Failed Prices test'
	PRINT '	There are ' + @count + ' styles missing a price:'
	PRINT '		' + @output
	SET @output = ''
END
ELSE BEGIN
	PRINT 'Passed Prices test'
END
SET @output = NULL

-- Descriptions test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + name FROM
(SELECT name + ' (' + vendor_product_id + ')' AS name FROM tbl_LoadFile_S12_MER WHERE type = 'configurable' AND (short_description IS NULL OR short_description = '')) AS x

SET @count = (SELECT COUNT(*) FROM tbl_LoadFile_S12_MER WHERE type = 'configurable' AND (short_description IS NULL OR short_description = ''))

IF @count <> 0 BEGIN
	PRINT 'Failed Descriptions test'
	PRINT '	There are ' + @count + ' styles missing a short description:'
	PRINT '		' + @output
	SET @output = ''
END
ELSE BEGIN
	PRINT 'Passed Descriptions test'
END
SET @output = NULL

-- Media Gallery test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + name FROM
(SELECT name FROM tbl_LoadFile_S12_MER WHERE type = 'configurable' AND media_gallery LIKE '%' + image + '%') AS x

SET @count = (SELECT COUNT(*) FROM tbl_LoadFile_S12_MER WHERE type = 'configurable' AND media_gallery LIKE '%' + image + '%')

IF @count <> 0 BEGIN
	PRINT 'Failed Media Gallery formatting test'
	PRINT '	There are ' + @count + ' configurable styles that have the image included in the media gallery:'
	PRINT '		' + @output
	SET @output = ''
END
ELSE BEGIN
	PRINT 'Passed Media Gallery test'
END
SET @output = NULL

-- Simples Without Photos test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + name FROM
(SELECT DISTINCT vendor_product_id + '-' + vendor_color_code  + ' (' + choose_color + ')' AS name FROM tbl_LoadFile_S12_MER WHERE type = 'simple' AND (image = '' OR image IS NULL)) AS x

SET @count = (SELECT COUNT(DISTINCT vendor_product_id + ' ' + choose_color) FROM tbl_LoadFile_S12_MER WHERE type = 'simple' AND (image = '' OR image IS NULL))

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

-- Missing Photo Files test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + image FROM
(SELECT DISTINCT image FROM tbl_LoadFile_S12_MER AS a LEFT JOIN tbl_RawData_S12_MER_Photos AS b ON a.image = b.filename WHERE b.filename IS NULL AND type = 'simple') AS x

SET @count = (SELECT COUNT(DISTINCT image) FROM tbl_LoadFile_S12_MER AS a LEFT JOIN tbl_RawData_S12_MER_Photos AS b ON a.image = b.filename WHERE b.filename IS NULL AND type = 'simple')

IF @count <> 0 BEGIN
	PRINT 'Failed Missing Photo Files test'
	PRINT '	There are ' + @count + ' image filenames referenced that we don''t have the files for:'
	PRINT '		' + @output
	SET @output = ''
END
ELSE BEGIN
	PRINT 'Passed Missing Photo Files test'
END
SET @output = NULL
GO

/**
 * This is the view that we will select data out of when we export to CSV. This view adds column headers and
 * wraps the column values in double quotes.
**/

UPDATE tbl_LoadFile_S12_MER SET url_key = LOWER(manufacturer) + '-' + LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(name,'Women''s ',''),'Men''s ',''),' ','-'),'''',''),'/','')) WHERE type = 'configurable'

DROP VIEW [dbo].[view_LoadFile_S12_MER]
GO

CREATE VIEW [dbo].[view_LoadFile_S12_MER]
AS
SELECT  '"store"' AS store, '"websites"' AS websites, '"type"' AS type, '"sku"' AS sku, '"name"' AS name, '"attribute_set"' AS attribute_set, 
        '"configurable_attributes"' AS configurable_attributes, '"has_options"' AS has_options, '"price"' AS price, '"cost"' AS cost, '"status"' AS status, '"tax_class_id"' AS tax_class_id, '"department"' AS department, 
        '"visibility"' AS visibility, '"image"' AS image, '"image_label"' AS image_label, '"small_image"' AS small_image, '"thumbnail"' AS thumbnail, '"media_gallery"' AS media_gallery, 
        '"choose_color"' AS choose_color, '"choose_size"' AS choose_size, '"vendor_sku"' AS vendor_sku, '"vendor_product_id"' AS vendor_product_id, '"vendor_color_code"' AS vendor_color_code, 
        '"vendor_size_code"' AS vendor_size_code, '"season"' AS season, '"short_description"' AS short_description, '"description"' AS description, '"features"' AS features, '"activities"' AS activities, '"weather"' AS weather, '"layering"' AS layering, '"care_instructions"' AS care_instructions,
        '"fabric"' AS fabric, '"fit"' AS fit, '"volume"' AS volume, '"manufacturer"' AS manufacturer, '"qty"' AS qty, '"is_in_stock"' AS is_in_stock, '"simples_skus"' AS simples_skus, '"url_key"' AS url_key,
        '"super_attribute_pricing"' AS super_attribute_pricing, '"videos"' AS videos, '"hs_tariff_id"' AS hs_tariff_id, '"origin"' AS origin, '"weight"' AS weight, '"us_skus"' AS us_skus, '"cs_skus"' AS cs_skus, '"xre_skus"' AS xre_skus
UNION ALL
SELECT  '"' + RTRIM(LTRIM(REPLACE(a.store,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.websites,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.type,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.sku,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.name + ' NEW!','"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.attribute_set,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.configurable_attributes,'"','""'))) + '"',
		'"' + RTRIM(LTRIM(REPLACE(a.has_options,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.price,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.cost,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.status,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.tax_class_id,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.gender,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.visibility,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE('+' + a.image,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.image_label,'"','""'))) + '"',
		'"' + RTRIM(LTRIM(REPLACE('+' + a.small_image,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE('+' + a.thumbnail,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.media_gallery,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.choose_color,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.choose_size,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.vendor_sku,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.vendor_product_id,'"','""'))) + '"',
		'"' + RTRIM(LTRIM(REPLACE(a.vendor_color_code,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.vendor_size_code,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.season,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a. short_description,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.description,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.features,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.activities,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.weather,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.layering,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.care_instructions,'"','""'))) + '"',
		'"' + RTRIM(LTRIM(REPLACE(a.fabric,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.fit,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.volume,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.manufacturer,'"','""'))) + '"','"0"','"' + CASE WHEN a.type = 'configurable' THEN '1' ELSE '0' END + '"','"' + RTRIM(LTRIM(REPLACE(a.simples_skus,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.url_key,'"','""'))) + '"',
		'"' + RTRIM(LTRIM(REPLACE(a.super_attribute_pricing,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.videos,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.hs_tariff,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.origin,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.weight,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.us_skus,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.cs_skus,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.xre_skus,'"','""'))) + '"'
FROM dbo.tbl_LoadFile_S12_MER AS a
GO

/**
 * Finally, we export our load file view to a CSV file using the BCP utility. Unfortunately BCP (at least the SQL Server 2008 version)
 * does not output UTF-8, so you then need to open helly-hansen-spring-2012.csv in a text editor and re-save it with UTF-8 encoding
 * prior to using the file with MAGMI. MAGMI requires UTF-8.
**/

DECLARE @sql varchar(1024)
SELECT @sql = 'bcp "SELECT * FROM LOT_Inventory.dbo.view_LoadFile_S12_MER" queryout "C:\Data\Shared\SQL\merrell-apparel-S12.csv" -w -t , -T -S ' + @@servername
EXEC master..xp_cmdshell @sql
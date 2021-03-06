/**
 * @category LiveOutThere.com
 * @package ETL/Helly Hansen
 * @author Drew Gillson <drew@liveoutthere.com>
**/

USE LOT_Inventory

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/**
 * The contents of this table come from the Excel spreadsheet "Helly Hansen - LiveOutThere.com.xlsx:Sheet2". In my
 * experience the best way to load raw data into SQL Server from Excel is, counter-intuitively, just copying and
 * pasting the spreadsheet into the edit rows screen in SQL Server Management Studio. This is faster than using
 * bcp or SSIS and actually handles character encoding more reliably.
**/
IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tbl_RawData_S12_HH_Additional]')
AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[tbl_RawData_S12_HH_Additional](
	Style [nvarchar](1024) NULL,
	Ordering [nvarchar](1024) NULL,
	StyleName [nvarchar](1024) NULL,
	CWCodeAndName [nvarchar](1024) NULL,
	BusinessArea [nvarchar](1024) NULL,
	Category [nvarchar](1024) NULL,
	SpecificationCategory [nvarchar](1024) NULL,
	Segmentation [nvarchar](1024) NULL,
	Collection [nvarchar](1024) NULL,
	ProductType [nvarchar](1024) NULL,
	ProductSubtype [nvarchar](1024) NULL,
	ProdWeight [nvarchar](1024) NULL,
	SalesMethod [nvarchar](1024) NULL,
	GenderDesc [nvarchar](1024) NULL,
	Season [nvarchar](1024) NULL,
	Photo [nvarchar](1024) NULL,
	Photo2 [nvarchar](1024) NULL,
	Photo3 [nvarchar](1024) NULL,
	Photo4 [nvarchar](1024) NULL,
	Photo5 [nvarchar](1024) NULL,
	Photo6 [nvarchar](1024) NULL,
	Photo7 [nvarchar](1024) NULL,
	Photo8 [nvarchar](1024) NULL,
	Photo9 [nvarchar](1024) NULL,
	Photo10 [nvarchar](1024) NULL,
	Photo11 [nvarchar](1024) NULL,
	Photo12 [nvarchar](1024) NULL,
	Photo13 [nvarchar](1024) NULL,
	Photo14 [nvarchar](1024) NULL,
	Photo15 [nvarchar](1024) NULL,
	Photo16 [nvarchar](1024) NULL,
	Photo17 [nvarchar](1024) NULL,
	Photo18 [nvarchar](1024) NULL,
	Photo19 [nvarchar](1024) NULL,
	Photo20 [nvarchar](1024) NULL,
	SizeRange [nvarchar](1024) NULL,
	SizesInSizeRange [nvarchar](1024) NULL,
	FiberContent [nvarchar](1024) NULL,
	HHTechnology [nvarchar](1024) NULL,
	TechLogo1 [nvarchar](1024) NULL,
	TechLogo2 [nvarchar](1024) NULL,
	ProductFeature [nvarchar](1024) NULL,
	ProductStatement [nvarchar](1024) NULL,
	Weight [nvarchar](1024) NULL,
	HTValue [nvarchar](1024) NULL,
	USD [nvarchar](1024) NULL
) ON [PRIMARY]

/**
 * The contents of this table come from the Excel spreadsheet "Helly Hansen - LiveOutThere.com.xlsx:Sheet1".
**/
IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tbl_RawData_S12_HH]')
AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[tbl_RawData_S12_HH](
	StyleCode [nvarchar](1024) NULL,
	StyleName [nvarchar](1024) NULL,
	ColorCode [nvarchar](1024) NULL,
	ColorName [nvarchar](1024) NULL,
	Size [nvarchar](1024) NULL,
	Gender [nvarchar](1024) NULL,
	RetailPriceCA [nvarchar](1024) NULL,
	WholeSaleCostCA [nvarchar](1024) NULL,
	EAN [nvarchar](1024) NULL,
	ProductGroupName [nvarchar](1024) NULL,
	BusinessAreaName [nvarchar](1024) NULL,
	ItemGroupDescription [nvarchar](1024) NULL,
	SKU [nvarchar](4000) NULL,
	ProductFeature [nvarchar](1024) NULL,
	LongDescription [nvarchar](4000) NULL,
	FabricContent [nvarchar](1024) NULL,
	CountryOfOrigin [nvarchar](1024) NULL,
	Weight [nvarchar](1024) NULL,
	Photo [nvarchar](1024) NULL
) ON [PRIMARY]

/**
 * The contents of this table originally came from the output of running "ls" in the directory containing
 * Helly Hansen photos, but for your purposes you can find the filenames in the file hh-photos.txt.
**/
IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tbl_RawData_S12_HH_Photos]')
AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[tbl_RawData_S12_HH_Photos] (
	[Filename] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Color] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Caption] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]

/**
 * This is the output table - the "load file" that gets exported to CSV using BCP, which we will upload to Magento
 * using the MAGMI data importer utility (http://sourceforge.net/apps/mediawiki/magmi/index.php?title=Main_Page).
**/
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tbl_LoadFile_S12_HH]')
AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[tbl_LoadFile_S12_HH]

CREATE TABLE [dbo].[tbl_LoadFile_S12_HH](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[store] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_HH_store]  DEFAULT ('admin'),
	[websites] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_HH_websites]  DEFAULT ('base'),
	[type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sku] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[name] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[categories] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[attribute_set] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_HH_attribute_set]  DEFAULT ('default'),
	[configurable_attributes] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[has_options] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[price] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cost] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_HH_status]  DEFAULT ('Enabled'),
	[tax_class_id] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_HH_tax_class]  DEFAULT ('Taxable Goods'),
	[gender] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[visibility] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_HH_visibility]  DEFAULT ('Nowhere'),
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
	[season] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_HH_season]  DEFAULT (N'Spring/Summer 2012'),
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
	[manufacturer] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_HH_manufacturer]  DEFAULT ('Helly Hansen'),
	[qty] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_HH_qty]  DEFAULT ((10)),
	[is_in_stock] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tbl_LoadFile_S12_HH_is_in_stock]  DEFAULT ((1)),
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
 CONSTRAINT [PK_tbl_LoadFile_S12_HH] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_tbl_LoadFile_S12_HH] ON [dbo].[tbl_LoadFile_S12_HH] 
(
	[sku] ASC,
	[type] ASC,
	[vendor_product_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/**
 * Here we update the color name column in the photos table by searching for the color code as part of the filename.
 * This is about as easy as it gets - in many cases the manufacturers don't name the photos in a logical way and it 
 * is a lot more difficult to get a good 1 to 1 match.
**/
UPDATE a SET
	Color = (SELECT TOP 1 dbo.ProperCase(ColorName) FROM tbl_RawData_S12_HH WHERE ColorCode = SUBSTRING(a.Filename,7,3))
FROM tbl_RawData_S12_HH_Photos AS a
WHERE Color IS NULL
GO

/**
 * These are all of the supporting functions used by the actual insert routine beginning on line 447. It is probably
 * best to skip ahead and then come back to review these functions later. These functions need to be tweaked for each
 * brand to deal with the specific data issues you will encounter.
**/
CREATE FUNCTION [dbo].[getMagentoConfigurableSKU]
(
	@brand nvarchar(4000), @model nvarchar(4000)
)
RETURNS nvarchar(4000)
AS
BEGIN
	RETURN @brand + '-' + @model
END
GO

CREATE FUNCTION [dbo].[getMagentoSimpleSKU]
(
	@brand nvarchar(4000), @model nvarchar(4000), @color nvarchar(4000), @size nvarchar(4000)
)
RETURNS nvarchar(4000)
AS
BEGIN
	RETURN @brand + '-' + @model + '-' + REPLACE(ISNULL(LTRIM(RTRIM(@color)),''),' ','') + '-' + ISNULL(LTRIM(RTRIM(@size)),'')
END
GO

CREATE FUNCTION [dbo].[toHTMLEntities] 
(
	@input varchar(8000)
)
RETURNS varchar(8000)
AS
BEGIN
	SET @input = REPLACE(@input,'¨','&trade;')
	SET @input = REPLACE(@input,'º','&deg;')
	SET @input = REPLACE(@input,'—','&mdash;')
	SET @input = REPLACE(@input,'™','&trade;')
	SET @input = REPLACE(@input,'©','&copy;')
	SET @input = REPLACE(@input,'’','&rsquo;')
	SET @input = REPLACE(@input,'®','&reg;')
	SET @input = REPLACE(@input,'¼','&frac14;')
	SET @input = REPLACE(@input,'½','&frac12;')
	SET @input = REPLACE(@input,'¾','&frac34;')
	SET @input = REPLACE(@input,'...','&hellip;')
	RETURN @input
END
GO

CREATE FUNCTION [dbo].[ProperCase](@Text AS varchar(8000))
RETURNS varchar(8000)
AS
BEGIN
   DECLARE @Reset bit, @Ret varchar(8000), @i int, @c char(1)

   SELECT @Reset = 1, @i=1, @Ret = '';
   
   WHILE (@i <= LEN(@Text)) -- ignore the last few chars in case of designations like II, VE, etc.
   	SELECT @c = SUBSTRING(@Text,@i,1),
               @Ret = @Ret + CASE WHEN @Reset=1 THEN UPPER(@c) ELSE LOWER(@c) END,
               @Reset = CASE WHEN @c LIKE '[a-zA-Z]' THEN 0 ELSE 1 END,
               @i = @i +1
   
	IF RIGHT(@Ret,3) LIKE ' [a-zA-Z0-9][a-zA-Z0-9]' BEGIN
		SET @Ret = LEFT(@Ret,LEN(@Ret)-3) + UPPER(RIGHT(@Ret,3))
	END
	RETURN @Ret
END
GO

CREATE FUNCTION [dbo].[getHHName]
(
	@name nvarchar(1024),
	@gender nvarchar(1024)
)
RETURNS nvarchar(4000)
AS
BEGIN
	SET @name = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(dbo.ProperCase(@name),' SS',' S/S'),' LS',' L/S'),'HH ',''),'Hp ','Hydro Power '),'Qd ','Quickdry '),' - Boys',''),' - Girls',''),' (6 Pack)',''),' Ht',' Helly Tech'),'Jkt','Jacket'),'\','/'),'Hydropower','Hydro Power'),' Upf',' UPF'),'New W ','New '),'  ',' ')
	
	SET @gender = CASE
					WHEN @gender = 'Womens' THEN 'Women''s'
					WHEN @gender = 'Mens' THEN 'Men''s'
					WHEN @gender = 'Kids Unisex' THEN 'Kids'''
					WHEN @gender = 'Kids Girl' THEN 'Girls'''
					WHEN @gender = 'Junior Unisex' THEN 'Kids'''
					WHEN @gender = 'Junior Girl' THEN 'Girls'''
					WHEN @gender = 'Junior Boy' THEN 'Boys'''
					ELSE ''
				  END

	SET @name = CASE
				  WHEN LEFT(@name,2) = 'W ' THEN @gender + ' ' + RIGHT(@name, LEN(@name)-2)
				  WHEN LEFT(@name,2) = 'K ' THEN @gender + ' ' + RIGHT(@name, LEN(@name)-2)
				  WHEN LEFT(@name,3) = 'Hh ' THEN RIGHT(@name, LEN(@name)-3)
				  WHEN @gender <> '' THEN @gender + ' ' + @name
				  ELSE @name
			    END

	RETURN @name
END
GO

CREATE FUNCTION [dbo].[getHHMediaGallery] 
(
	@productid nvarchar(4000)
)
RETURNS nvarchar(4000)
AS
BEGIN
	DECLARE @output nvarchar(4000)
	
	(SELECT @output = COALESCE(@output + ';', '') + Photo FROM
	(SELECT DISTINCT image + CASE WHEN image_label IS NOT NULL THEN '::' + image_label ELSE '' END AS Photo FROM tbl_LoadFile_S12_HH WHERE type = 'simple' AND vendor_product_id = @productid AND image <> (SELECT TOP 1 image FROM tbl_LoadFile_S12_HH WHERE type = 'configurable' AND vendor_product_id = @productid)) AS x)
	 	
	RETURN @output

END
GO

CREATE FUNCTION [dbo].[getHHGender]
(
	@gender nvarchar(1024)
)
RETURNS nvarchar(4000)
AS
BEGIN
	
	SET @gender = CASE
					WHEN @gender = 'Womens' THEN 'Women'
					WHEN @gender = 'Mens' THEN 'Men'
					WHEN @gender = 'Kids Unisex' THEN 'Boy|Girl'
					WHEN @gender = 'Kids Girl' THEN 'Girl'
					WHEN @gender = 'Junior Unisex' THEN 'Boy|Girl'
					WHEN @gender = 'Junior Girl' THEN 'Girl'
					WHEN @gender = 'Junior Boy' THEN 'Boy'
					ELSE 'Women|Men'
				  END
	RETURN @gender
END
GO

CREATE FUNCTION [dbo].[getHHCategory]
(
	@cat nvarchar(1024)
)
RETURNS nvarchar(4000)
AS
BEGIN
	
	SET @cat = CASE
					WHEN @cat LIKE '%Accessories%Bags%' THEN 'Backpacks'
					WHEN @cat LIKE '%Accessories%Caps%' THEN 'Accessories/Hats & Toques'
					WHEN @cat LIKE '%Accessories%Other accessories%' THEN 'Accessories'
					WHEN @cat LIKE '%Accessories%Sunglasses%' THEN 'Accessories/Sunglasses'
					WHEN @cat LIKE '%Apparel%Bikini%' THEN 'Swimwear'
					WHEN @cat LIKE '%Apparel%Caps%' THEN 'Accessories/Hats & Toques'
					WHEN @cat LIKE '%Apparel%Hoodie/Sweat%' THEN 'Tops/Hoodies & Sweaters'
					WHEN @cat LIKE '%Apparel%Jacket%Hardshell%' OR @cat LIKE '%Apparel/Jacket%Rain%' THEN 'More Jackets/Waterproof Jackets'
					WHEN @cat LIKE '%Apparel%Jacket%Softshell%' THEN 'More Jackets/Softshell Jackets'
					WHEN @cat LIKE '%Apparel%Jacket%Fleece%' THEN 'More Jackets/Fleece Jackets'
					WHEN @cat LIKE '%Apparel%Jacket%' THEN 'More Jackets'
					WHEN @cat LIKE '%Apparel%Knit%' THEN 'Tops/Hoodies & Sweaters'
					WHEN @cat LIKE '%Apparel%Other%' THEN 'Tops'
					WHEN @cat LIKE '%Apparel%Pant%' THEN 'Bottoms/Pants'
					WHEN @cat LIKE '%Apparel%Polo%' THEN 'Tops/Polos;;Tops/Shirts'
					WHEN @cat LIKE '%Apparel%Set%' THEN 'Tops;;Bottoms'
					WHEN @cat LIKE '%Apparel%Shirt%' THEN 'Tops/Shirts'
					WHEN @cat LIKE '%Apparel%Short%' THEN 'Bottoms/Shorts'
					WHEN @cat LIKE '%Apparel%Skirt%' THEN 'Bottoms/Skirts'
					WHEN @cat LIKE '%Apparel%Socks%' THEN 'Accessories/Socks'
					WHEN @cat LIKE '%Apparel%Top%' THEN 'Tops/Shirts'
					WHEN @cat LIKE '%Apparel%T-shirt%' THEN 'Tops/Tees'
					WHEN @cat LIKE '%Apparel%Vest%' THEN 'Tops/Vests'
					WHEN @cat LIKE '%Footwear%Boot%' THEN 'Footwear/Hiking'
					WHEN @cat LIKE '%Footwear%Sandal%' THEN 'Footwear/Sandals'
					WHEN @cat LIKE '%Footwear%Shoe%' THEN 'Footwear/City & Fashion'
			   END
	
	RETURN @cat
END
GO

CREATE FUNCTION [dbo].[getHHAssociatedProducts] 
(
	@productid varchar(255)
)
RETURNS nvarchar(4000)
AS
BEGIN
	DECLARE @output nvarchar(4000)

	(SELECT @output = COALESCE(@output + ',', '') + sku FROM
	(SELECT sku AS sku
		FROM tbl_LoadFile_S12_HH WHERE (vendor_product_id = @productid) AND type = 'simple')
	 AS x)
	
	RETURN @output
END
GO

CREATE FUNCTION [dbo].[getHHUpsellProducts] 
(
	@category nvarchar(255)
)
RETURNS varchar(1024)
AS
BEGIN
	DECLARE @output nvarchar(4000)
	
	(SELECT @output = COALESCE(@output + ',', '') + sku FROM
	(SELECT 'HH-' + Style AS sku
		FROM tbl_RawData_S12_HH_Additional AS a WHERE a.Collection + a.ProductType = @category)
	 AS x)
	 	
	RETURN @output
END
GO

CREATE FUNCTION [dbo].[getHHUsage]
(
	@usage nvarchar(1024)
)
RETURNS nvarchar(4000)
AS
BEGIN	
	SET @usage = CASE
					WHEN @usage LIKE '%WATER%' OR @usage LIKE '%HYDRO%' OR @usage LIKE '%OFFSHORE%' THEN 'Watersports'
					WHEN @usage LIKE '%TRAINING%' THEN 'Training|Running'
			     END
	RETURN @usage
END
GO

CREATE FUNCTION [dbo].[getHHWeather]
(
	@weather nvarchar(1024)
)
RETURNS nvarchar(4000)
AS
BEGIN	
	SET @weather = CASE
					WHEN @weather LIKE '%COOL%' THEN 'Hot'
					WHEN @weather LIKE '%RAIN%' THEN 'Rain'
			     END
	RETURN @weather
END
GO

/**
 * Here we insert "simple products" to the load file table by selecting data out of the raw table. Simple products, or
 * variants, are the available colors and sizes (SKUs) for a given piece of apparel. For instance, a shirt in size small
 * and color blue is a simple product.
**/
INSERT INTO tbl_LoadFile_S12_HH (
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
		image_label,
		hs_tariff,
		origin,
		weight
)
SELECT DISTINCT
		dbo.getMagentoSimpleSKU('HH', a.StyleCode, a.ColorCode, a.Size) AS sku,
		a.StyleCode AS vendor_product_id,
		dbo.getHHName(a.StyleName, a.Gender) AS productname,
		dbo.getHHGender(a.Gender) AS gender,
		REPLACE(dbo.ProperCase(a.ColorName),'Hh ','HH ') AS choose_color,
		REPLACE(REPLACE(a.Size,'.5W','½'),'.5','½') AS choose_size,
		a.ColorCode AS vendor_color_code,
		a.Size AS vendor_size_code,
		a.EAN AS vendor_sku,
		CAST(a.RetailPriceCA AS float) - 0.01 AS price,
		CAST(a.WholeSaleCostCA AS float) AS cost,
		0 AS has_options,
		'simple' AS type,
		a.Photo AS image,
		REPLACE(dbo.ProperCase(a.ColorName),'Hh ','HH ') AS image_label,
		'' AS hs_tariff,
		a.CountryOfOrigin AS origin,
		CASE WHEN a.Weight <> '' AND a.Weight <> '0.00%' THEN a.Weight + ' lbs. / ' + CAST(ROUND(CAST(a.Weight AS float) / 2.2,2) AS varchar(50)) + ' kg' ELSE '' END AS weight
FROM tbl_RawData_S12_HH AS a
WHERE ISNUMERIC(a.RetailPriceCA) = 1

/**
 * Here we insert "configurable products", which are the parent SKUs for the simple products. In Magento, we only list
 * configurable products available-to-sell, and you must choose a color and a size from the product detail page. These
 * products contain all of the detailed information, bullet points, features, etc. that you can use to make your purchase
 * decision. MAGMI automatically relates configurable products to simple products using the string of simple product SKUs
 * found in the simples_skus column.
**/
INSERT INTO tbl_LoadFile_S12_HH (
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
	activities,
	weather,
	description,
	has_options,
	type,
	visibility,
	weight,
	origin
)
SELECT DISTINCT
		dbo.getMagentoConfigurableSKU('HH', a.StyleCode) AS sku,
		'choose_color,choose_size' AS config_attributes,
		a.StyleCode AS model,
		dbo.getHHCategory(ISNULL(a.BusinessAreaName,'') + ISNULL(a.ItemGroupDescription,'') + ISNULL(b.Collection,'') + ISNULL(b.ProductType,'') + ISNULL(b.ProductSubtype,'')) AS categories,
		dbo.getHHName(a.StyleName, a.Gender) AS name,
		dbo.getHHGender(a.Gender) AS gender,
		(SELECT MIN(price) FROM tbl_LoadFile_S12_HH WHERE vendor_product_id = a.StyleCode) AS price,
		(SELECT MIN(cost) FROM tbl_LoadFile_S12_HH WHERE vendor_product_id = a.StyleCode) AS cost,
		CASE WHEN b.ProductStatement <> '' AND b.ProductStatement IS NOT NULL THEN dbo.toHTMLEntities(b.ProductStatement) ELSE dbo.toHTMLEntities(a.LongDescription) END AS short_description,
		dbo.ProperCase(b.FiberContent) AS fabric,
		dbo.toHTMLEntities(b.ProductFeature) AS features,
		dbo.getHHUsage(ISNULL(b.Collection,'') + ISNULL(b.ProductType,'') + ISNULL(b.ProductSubtype,'')) AS usage,
		dbo.getHHWeather(ISNULL(b.Collection,'') + ISNULL(b.ProductType,'') + ISNULL(b.ProductSubtype,'')) AS weather,
		CASE WHEN b.ProductStatement <> '' AND b.ProductStatement IS NOT NULL AND b.ProductStatement <> a.LongDescription THEN dbo.toHTMLEntities(a.LongDescription) ELSE '&nbsp;' END AS description,
		'1' AS has_options,
		'configurable' AS type,
		'Catalog, Search' AS visibility,
		CASE WHEN a.Weight <> '' AND a.Weight <> '0.00%' THEN (SELECT MIN(Weight) FROM tbl_RawData_S12_HH WHERE StyleCode = a.StyleCode) + ' lbs. / ' + CAST(ROUND(CAST((SELECT MIN(Weight) FROM tbl_RawData_S12_HH WHERE StyleCode = a.StyleCode) AS float) / 2.2,2) AS varchar(50)) + ' kg' ELSE '' END AS weight,
		a.CountryOfOrigin
FROM tbl_RawData_S12_HH AS a
LEFT OUTER JOIN tbl_RawData_S12_HH_Additional AS b ON a.StyleCode = b.Style

/**
 * Here we update a few columns used by configurable products. The reason this is split into a separate UPDATE statement, rather
 * than being included in the INSERT statement above, is because it is much, much faster. If we insert these column values above they
 * get calculated on the entire set (because it is executed before the DISTINCT), rather than on single rows.
**/
UPDATE a SET
	image = (SELECT TOP 1 image FROM tbl_LoadFile_S12_HH WHERE type = 'simple' AND vendor_product_id = a.vendor_product_id ORDER BY image_label DESC),
	image_label = (SELECT TOP 1 image_label FROM tbl_LoadFile_S12_HH WHERE type = 'simple' AND vendor_product_id = a.vendor_product_id ORDER BY image_label DESC),
	simples_skus = dbo.getHHAssociatedProducts(a.vendor_product_id),
	us_skus = dbo.getHHUpsellProducts((SELECT DISTINCT b.Collection + b.ProductType FROM tbl_RawData_S12_HH_Additional AS b WHERE Style = a.vendor_product_id))
FROM tbl_LoadFile_S12_HH AS a
WHERE type = 'configurable'

/**
 * We need to do this last because dbo.getHHMediaGallery depends on the image columns we updated above.
**/
UPDATE a SET
	media_gallery = dbo.getHHMediaGallery(a.vendor_product_id)
FROM tbl_LoadFile_S12_HH AS a
WHERE type = 'configurable'

/**
 * small_image and thumbnail contain the same value as image
**/
UPDATE tbl_LoadFile_S12_HH SET small_image = image, thumbnail = image WHERE image IS NOT NULL
GO

/**
 * Almost done! Now we have to do some sanity checks and run some tests. The following routines all check
 * for data consistency and accuracy before we output to CSV and upload to Magento.
**/

DECLARE @output varchar(MAX), @count nvarchar(3)

-- Categories test
PRINT ''
SELECT @output = COALESCE(@output + CHAR(13) + '		', '') + name FROM
(SELECT name FROM tbl_LoadFile_S12_HH WHERE type = 'configurable' AND categories IS NULL) AS x

SET @count = (SELECT COUNT(*) FROM tbl_LoadFile_S12_HH WHERE type = 'configurable' AND categories IS NULL)

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
(SELECT DISTINCT sku FROM tbl_LoadFile_S12_HH AS a WHERE (SELECT COUNT(*) FROM tbl_LoadFile_S12_HH WHERE sku = a.sku) > 1) AS x

SET @count = (SELECT COUNT(DISTINCT sku) FROM tbl_LoadFile_S12_HH AS a WHERE (SELECT COUNT(*) FROM tbl_LoadFile_S12_HH WHERE sku = a.sku) > 1)

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
(SELECT a.sku AS sku FROM tbl_LoadFile_S12_HH AS a LEFT JOIN tbl_LoadFile_S12_HH AS b
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
(SELECT name + ' (' + vendor_product_id + ')' AS name FROM tbl_LoadFile_S12_HH WHERE type = 'configurable' AND (image IS NULL or image_label IS NULL)) AS x

SET @count = (SELECT COUNT(*) FROM tbl_LoadFile_S12_HH WHERE type = 'configurable' AND (image IS NULL or image_label IS NULL))

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
(SELECT vendor_product_id FROM tbl_LoadFile_S12_HH WHERE CAST(price AS float) <= 0 OR price IS NULL) AS x

SET @count = (SELECT COUNT(*) FROM tbl_LoadFile_S12_HH WHERE CAST(price AS float) <= 0 OR price IS NULL)

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
(SELECT name + ' (' + vendor_product_id + ')' AS name FROM tbl_LoadFile_S12_HH WHERE type = 'configurable' AND (short_description IS NULL OR short_description = '')) AS x

SET @count = (SELECT COUNT(*) FROM tbl_LoadFile_S12_HH WHERE type = 'configurable' AND (short_description IS NULL OR short_description = ''))

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
(SELECT name FROM tbl_LoadFile_S12_HH WHERE type = 'configurable' AND media_gallery LIKE '%' + image + '%') AS x

SET @count = (SELECT COUNT(*) FROM tbl_LoadFile_S12_HH WHERE type = 'configurable' AND media_gallery LIKE '%' + image + '%')

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
(SELECT DISTINCT vendor_product_id + '-' + vendor_color_code  + ' (' + choose_color + ')' AS name FROM tbl_LoadFile_S12_HH WHERE type = 'simple' AND (image = '' OR image IS NULL)) AS x

SET @count = (SELECT COUNT(DISTINCT vendor_product_id + ' ' + choose_color) FROM tbl_LoadFile_S12_HH WHERE type = 'simple' AND (image = '' OR image IS NULL))

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
(SELECT DISTINCT image FROM tbl_LoadFile_S12_HH AS a LEFT JOIN tbl_RawData_S12_HH_Photos AS b ON a.image = b.filename WHERE b.filename IS NULL AND type = 'simple') AS x

SET @count = (SELECT COUNT(DISTINCT image) FROM tbl_LoadFile_S12_HH AS a LEFT JOIN tbl_RawData_S12_HH_Photos AS b ON a.image = b.filename WHERE b.filename IS NULL AND type = 'simple')

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
CREATE VIEW [dbo].[view_LoadFile_S12_HH]
AS
SELECT  '"store"' AS store, '"websites"' AS websites, '"type"' AS type, '"sku"' AS sku, '"name"' AS name, '"categories"' AS categories, '"attribute_set"' AS attribute_set, 
        '"configurable_attributes"' AS configurable_attributes, '"has_options"' AS has_options, '"price"' AS price, '"cost"' AS cost, '"status"' AS status, '"tax_class_id"' AS tax_class_id, '"gender"' AS gender, 
        '"visibility"' AS visibility, '"image"' AS image, '"image_label"' AS image_label, '"small_image"' AS small_image, '"thumbnail"' AS thumbnail, '"media_gallery"' AS media_gallery, 
        '"choose_color"' AS choose_color, '"choose_size"' AS choose_size, '"vendor_sku"' AS vendor_sku, '"vendor_product_id"' AS vendor_product_id, '"vendor_color_code"' AS vendor_color_code, 
        '"vendor_size_code"' AS vendor_size_code, '"season"' AS season, '"short_description"' AS short_description, '"description"' AS description, '"features"' AS features, '"activities"' AS activities, '"weather"' AS weather, '"layering"' AS layering, '"care_instructions"' AS care_instructions,
        '"fabric"' AS fabric, '"fit"' AS fit, '"volume"' AS volume, '"manufacturer"' AS manufacturer, '"qty"' AS qty, '"is_in_stock"' AS is_in_stock, '"simples_skus"' AS simples_skus, '"url_key"' AS url_key,
        '"super_attribute_pricing"' AS super_attribute_pricing, '"videos"' AS videos, '"hs_tariff_id"' AS hs_tariff_id, '"origin"' AS origin, '"weight"' AS weight, '"us_skus"' AS us_skus, '"cs_skus"' AS cs_skus, '"xre_skus"' AS xre_skus
UNION ALL
SELECT  '"' + RTRIM(LTRIM(REPLACE(a.store,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.websites,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.type,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.sku,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.name + ' NEW!','"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.categories,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.attribute_set,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.configurable_attributes,'"','""'))) + '"',
		'"' + RTRIM(LTRIM(REPLACE(a.has_options,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.price,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.cost,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.status,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.tax_class_id,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.gender,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.visibility,'"','""'))) + '"','"' + LOWER(RTRIM(LTRIM(REPLACE('+' + a.image,'"','""')))) + '"','"' + RTRIM(LTRIM(REPLACE(a.image_label,'"','""'))) + '"',
		'"' + LOWER(RTRIM(LTRIM(REPLACE('+' + a.small_image,'"','""')))) + '"','"' + LOWER(RTRIM(LTRIM(REPLACE('+' + a.thumbnail,'"','""')))) + '"','"' + RTRIM(LTRIM(REPLACE(a.media_gallery,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.choose_color,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.choose_size,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.vendor_sku,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.vendor_product_id,'"','""'))) + '"',
		'"' + RTRIM(LTRIM(REPLACE(a.vendor_color_code,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.vendor_size_code,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.season,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a. short_description,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.description,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.features,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.activities,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.weather,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.layering,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.care_instructions,'"','""'))) + '"',
		'"' + RTRIM(LTRIM(REPLACE(a.fabric,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.fit,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.volume,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.manufacturer,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.qty,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.is_in_stock,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.simples_skus,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.url_key,'"','""'))) + '"',
		'"' + RTRIM(LTRIM(REPLACE(a.super_attribute_pricing,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.videos,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.hs_tariff,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.origin,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.weight,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.us_skus,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.cs_skus,'"','""'))) + '"','"' + RTRIM(LTRIM(REPLACE(a.xre_skus,'"','""'))) + '"'
FROM dbo.tbl_LoadFile_S12_HH
GO

/**
 * Finally, we export our load file view to a CSV file using the BCP utility. Unfortunately BCP (at least the SQL Server 2008 verison)
 * does not output UTF-8, so you then need to open helly-hansen-spring-2012.csv in a text editor and re-save it with UTF-8 encoding
 * prior to using the file with MAGMI. MAGMI requires UTF-8.
**/
EXEC master.dbo.sp_configure 'show advanced options', 1
RECONFIGURE

EXEC master.dbo.sp_configure 'xp_cmdshell', 1
RECONFIGURE

DECLARE @sql varchar(1024)
SELECT @sql = 'bcp "SELECT * FROM LOT_Inventory.dbo.view_LoadFile_S12_HH" queryout "C:\helly-hansen-spring-2012.csv" -w -t , -T -S ' + @@servername
EXEC master..xp_cmdshell @sql
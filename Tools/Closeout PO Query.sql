SELECT DISTINCT store, websites, type, REPLACE(sku,'FW12A','SS13C') AS sku, REPLACE(REPLACE(name,'Women''s ',''),'Men''s ','') AS name, categories, attribute_set, configurable_attributes, has_options, price, cost, super_attribute_pricing, status, tax_class_id, gender AS 'department', visibility, 
                      image, image_label, small_image, thumbnail, choose_color, choose_size, vendor_sku AS 'ean', vendor_product_id, vendor_color_code, vendor_size_code, 
                      'SS13 Closeout' AS season_id, short_description, description, features, activities, weather, layering, care_instructions, fabric, fit, volume, manufacturer, qty, is_in_stock, simples_skus, 
                      REPLACE(url_key,'fw12a','ss13c'), 'Merrell ' + REPLACE(REPLACE(name,'Women''s ',''),'Men''s ','') + CASE WHEN gender = 'Men' THEN ' - Men''s' WHEN gender = 'Women' THEN ' - Women''s' END AS meta_title, videos, weight, '' AS merchandise_priority, '1' AS never_backorder, '0' AS backorders, '1' AS manage_stock, '1' AS use_config_backorders, '1' AS use_config_manage_stock
FROM tbl_LoadFile_F12_MER
WHERE type = 'simple' AND vendor_sku IN('797240857517',
'797240857524',
'797240857531',
'797240857548',
'797240857555',
'797240857562',
'797240857579',
'797240857586',
'797240857593',
'797240857609',
'797240857616',
'883290954532',
'797240857623',
'773984990772',
'773984990789',
'18461320599',
'773984990796',
'773984990802',
'773984990819',
'773984572480',
'773984572497',
'773984572503',
'773984572510',
'773984572527',
'773984572534',
'773984572541',
'773984572558',
'773984572565',
'773984572572',
'773984572589',
'883290663830',
'773984572596',
'773984572602',
'773984572619',
'773040609433',
'773040609440',
'773040609457',
'773040609464',
'773040609471',
'773040609488',
'773040609495',
'773040609501',
'773040609518',
'773040609525',
'773040609532',
'773984001058',
'773040609549',
'773040609556',
'773040609563',
'773040596313',
'773040596320',
'773040596337',
'773040596344',
'773040596351',
'773040596368',
'773040596375',
'773040596382',
'773040596399',
'773040596405',
'773040596412',
'773040995222',
'773040596429',
'773040596436',
'773040596443',
'773984990680',
'773984990697',
'773984990703',
'773984990710',
'773984990727',
'773984990734',
'773984990741',
'773984990758',
'773984990765')

SELECT DISTINCT store, websites, type, REPLACE(sku,'FW12A','SS13C') AS sku, REPLACE(REPLACE(name,'Women''s ',''),'Men''s ','') AS name, categories, attribute_set, configurable_attributes, has_options, price, cost, super_attribute_pricing, status, tax_class_id, gender AS 'department', visibility, 
                      image, image_label, small_image, thumbnail, choose_color, choose_size, vendor_sku AS 'ean', vendor_product_id, vendor_color_code, vendor_size_code, 
                      'SS13 Closeout' AS season_id, short_description, description, features, activities, weather, layering, care_instructions, fabric, fit, volume, manufacturer, qty, is_in_stock, simples_skus, 
                      REPLACE(url_key,'fw12a','ss13c'), 'Merrell ' + REPLACE(REPLACE(name,'Women''s ',''),'Men''s ','') + CASE WHEN gender = 'Men' THEN ' - Men''s' WHEN gender = 'Women' THEN ' - Women''s' END AS meta_title, videos, weight, '' AS merchandise_priority, '1' AS never_backorder, '0' AS backorders, '1' AS manage_stock, '1' AS use_config_backorders, '1' AS use_config_manage_stock
FROM tbl_LoadFile_F12_MER
WHERE type = 'configurable' AND vendor_product_id IN('AvianLightVentilator',
'WildernessCanyon',
'BareAccess',
'TrailGlove')
--Get all products of selected brand

SELECT 
	product_id AS "id", 
	b.brand_name AS "brand", 
	product_category_id AS "category",
	product_name, 
	product_price AS "price",
	product_average_rating AS "rating"
FROM product
INNER JOIN (
  SELECT brand_id, brand_name
  FROM brand
  WHERE brand_name = 'INSERT_NAME!'
) b ON product_brand_id = b.brand_id;

	
--Get all product variations for the selected brand

SELECT 
	product_variant_id AS "id",
	product_variant_color AS "color",
	prduct_variant_size AS "size",
	product_name,
	product_variant_sku AS "sku"
FROM (
  SELECT brand_id, brand_name
  FROM brand
  WHERE brand_name = 'INSERT_NAME!'
) b
INNER JOIN product ON 
	product_brand_id = b.brand_id
INNER JOIN product_variant ON 
	product_id = product_variant_product_id;

--Select all brands with the number of their products respectively. 
--Order by the number of products.

SELECT 
	brand_name AS "brand", 
	COUNT(product_id) AS "total"
FROM brand
INNER JOIN product ON product_brand_id = brand_id
GROUP BY brand_id
ORDER BY total DESC;

--Get all products for a given category and section.

SELECT 
	product_id AS "id",  
	category_name AS "category", 
	product_name, 
	product_price AS "prict", 
	product_average_rating AS "rating"
FROM product
INNER JOIN category ON category_id = product_category_id
INNER JOIN section_category ON section_category_category_id = category_id
INNER JOIN section ON section_id = section_category_section_id
WHERE category_name = 'INSERT_NAME' AND section_name = 'INSERT_NAME';

--Get all completed orders with a given product. 
--Order from newest to latest.

SELECT
	order_id AS "id",
	order_user_id AS "user_id",
	order_address_id as "address_id",
	order_price AS "price",
	order_date AS "date",
	p.product_name
FROM (
	SELECT 
	       product_id, 
	       product_name
	FROM   product
	WHERE  product_name = 'INSERT_NAME'
     ) p
INNER JOIN product_variant ON product_variant_product_id = p.product_id
INNER JOIN order_items ON order_items_product_variant_id = product_variant_id
INNER JOIN "order" ON order_items_order_id = order_id
--WHERE order_status = 'completed'
ORDER BY date DESC;

--Get all reviews for a given product. 
--Implement this as a viewtable which contains rating,
--comment and info of a person who left a comment.
SELECT 
	review_rating AS "rating",
	review_comment AS "comment",
	user_first_name || " " || user_last_name AS "name",
	user_email AS "email",
	user_phone AS "phone"
FROM (
	SELECT 
	       product_id, 
	       product_name
	FROM   product
	WHERE  product_name = 'INSERT_NAME'
     ) p
INNER JOIN review ON p.product_id = review_product_id
INNER JOIN "user" ON review_user_id = user_id;

CREATE VIEW temp_rid_en as
SELECT page_title as temp_page_title, 
SUM(count_views) AS temp_count_views,
domain_code
FROM wiki_traffic
GROUP BY page_title, domain_code
HAVING domain_code NOT LIKE 'en%'
ORDER BY temp_count_views desc;

DROP VIEW temp_rid_en;

CREATE TABLE wiki_traffic_rid_en (
	page_title STRING,
	count_views INT,
	domain_code STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' '
TBLPROPERTIES("skip.header.line.count"="1");

INSERT INTO wiki_traffic_rid_en (page_title, count_views, domain_code)
SELECT temp_page_title, temp_count_views, domain_code FROM temp_rid_en;

DROP TABLE wiki_traffic_rid_en;

SELECT page_title, 
SUM(count_views) AS total
FROM wiki_traffic_rid_en
GROUP BY page_title
HAVING page_title NOT LIKE 'Wiki%'
ORDER BY total desc;
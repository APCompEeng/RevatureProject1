-- start by creating the database
CREATE DATABASE wikipedia;
--make sure you have it
SHOW DATABASES;

--use the created database
USE wikipedia;
USE default;

CREATE TABLE wiki_data (
	prev STRING,
	curr STRING,
	wiki_type STRING,
	occurences INT)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY '\t'
	TBLPROPERTIES("skip.header.line.count"="1");

LOAD DATA LOCAL INPATH '/home/apesch/Projects/revatureProject1/clickstream-enwiki-2020-12.tsv' INTO TABLE wiki_data;
	
CREATE TABLE wiki_traffic (
	domain_code STRING,
	page_title STRING,
	count_views INT,
	total_response_size INT)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ' '
	TBLPROPERTIES("skip.header.line.count"="1");

LOAD DATA INPATH '/user/apesch/pageviews-20210120/pageviews-20210120-000000' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_01' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_02' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_03' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_04' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_05' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_06' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_07' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_08' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_09' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_10' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_11' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_12' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_13' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_14' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_15' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_16' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_17' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_18' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_19' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_20' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_21' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_22' INTO TABLE wiki_traffic;
LOAD DATA INPATH '/user/apesch/pageviews-20210120_23' INTO TABLE wiki_traffic;


CREATE TABLE en_wiki_traffic (
	page_title STRING,
	count_views INT,
	total_response_size INT)
PARTITIONED BY (domain_code STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' '
TBLPROPERTIES("skip.header.line.count"="1");

INSERT INTO en_wiki_traffic PARTITION(domain_code = 'en')
SELECT page_title, count_views, total_response_size FROM wiki_traffic WHERE domain_code = 'en';

INSERT INTO en_wiki_traffic PARTITION(domain_code = 'en.m')
SELECT page_title, count_views, total_response_size FROM wiki_traffic WHERE domain_code = 'en.m';

--Question 1 answer
--CREATE VIEW question1 as
SELECT page_title, 
SUM(count_views) AS total
FROM en_wiki_traffic
GROUP BY page_title
ORDER BY total desc;

CREATE TABLE pageviews (
	page_title STRING,
	total_count_views INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t';

INSERT INTO pageviews
SELECT page_title, total FROM temp_pageviews;


CREATE TABLE wiki_view (
	prev STRING,
	curr STRING,
	occurences INT)
PARTITIONED BY (wiki_type STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t';


INSERT INTO wiki_view PARTITION(wiki_type = 'link')
SELECT prev, curr, occurences FROM wiki_data WHERE wiki_type = 'link';


-- PROBLEM 2: What English wikipedia article has the largest fraction of its readers follow an internal link to another wikipedia article?

CREATE VIEW temp_num_of_clicks as
SELECT curr, 
SUM(occurences) AS n
FROM wiki_view 
GROUP BY curr
HAVING n >= 10
ORDER BY n desc;

CREATE TABLE num_of_clicks (
	curr STRING,
	total_occurences INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t';

INSERT INTO num_of_clicks
SELECT curr, n FROM temp_num_of_clicks;

-- ANSWER to QUESTION 2
--CREATE VIEW question2 as
SELECT num_of_clicks.curr, 
total_occurences, 
pageviews.total_count_views,
num_of_clicks.total_occurences/(pageviews.total_count_views * 30) AS link_fraction
FROM num_of_clicks
INNER JOIN pageviews
ON (num_of_clicks.curr = pageviews.page_title)
ORDER BY link_fraction desc;

-- CREATE new table for question2 to reference it later
CREATE TABLE question2Table (
	curr STRING,
	total_occurences INT,
	total_count_views INT,
	link_fraction DOUBLE)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ' '
	TBLPROPERTIES("skip.header.line.count"="1");

INSERT INTO question2Table
SELECT curr, total_occurences, total_count_views, link_fraction FROM question2;


-- CREATE new table for december wiki_traffic to match it up with the dec clickstream we already have
CREATE TABLE dec_wiki_traffic (
	domain_code STRING,
	page_title STRING,
	count_views INT,
	total_response_size INT)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ' '
	TBLPROPERTIES("skip.header.line.count"="1");

LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-000000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-010000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-020000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-030000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-040000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-050000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-060000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-070000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-080000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-090000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-100000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-110000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-120000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-130000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-140000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-150000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-160000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-170000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-180000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-190000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-200000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-210000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-220000' INTO TABLE dec_wiki_traffic;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-230000' INTO TABLE dec_wiki_traffic;

CREATE TABLE en_dec_wiki_traffic (
	page_title STRING,
	count_views INT,
	total_response_size INT)
PARTITIONED BY (domain_code STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' '
TBLPROPERTIES("skip.header.line.count"="1");

INSERT INTO en_dec_wiki_traffic PARTITION(domain_code = 'en')
SELECT page_title, count_views, total_response_size FROM dec_wiki_traffic WHERE domain_code = 'en';

INSERT INTO en_dec_wiki_traffic PARTITION(domain_code = 'en.m')
SELECT page_title, count_views, total_response_size FROM dec_wiki_traffic WHERE domain_code = 'en.m';

CREATE VIEW temp_pageviews as
SELECT page_title, 
SUM(count_views) AS total
FROM en_dec_wiki_traffic
GROUP BY page_title
ORDER BY total desc;

--PROBLEM 3 What series of wikipedia articles, starting with Hotel California, keeps the largest fraction of its readers clicking on internal links?

--Command to check the highest link fraction from the question 2 table
-- Hotel_California has a fraction of 0.6035234121464997
-- Steuart_Smith has a fraction of 5.185714285714286
-- Scott_F._Crago has a fraction of 9.433333333333334
-- Timothy_Drury has a fraction of 7.948717948717949
-- Total is 234.673999365
--The reason this is so high is because we can get the number of clicks between articles for the entire month, but we're only pulling from 
-- one day for the number of views on the page. If that day was a slow day for the page, it won't accurately reflect the data
SELECT prev, 
wiki_view.curr, 
occurences,
question2Table.link_fraction
FROM wiki_view 
INNER JOIN question2Table
	ON (wiki_view.prev = question2Table.curr)
GROUP BY wiki_view.curr, prev, occurences, question2Table.link_fraction
HAVING wiki_view.curr LIKE 'Scott_F._Crago'
ORDER BY question2Table.link_fraction desc;

-- Hotel_California has a fraction of 0.6035234121464997
SELECT * FROM question2Table
GROUP BY curr, total_occurences, total_count_views, link_fraction 
HAVING curr LIKE 'Hotel_California';

-- Hotel_California_(Eagles_album) has a fraction of 2.0026063100137175
SELECT * FROM question2Table
GROUP BY curr, total_occurences, total_count_views, link_fraction 
HAVING curr LIKE 'Hotel_California_(Eagles_album)';

-- Eagles_(band) has a fraction of 0.9884492951341519
SELECT * FROM question2Table
GROUP BY curr, total_occurences, total_count_views, link_fraction 
HAVING curr LIKE 'Eagles_(band)';

-- Glenn_Frey has a fraction of 3.7974051896207586
SELECT * FROM question2Table
GROUP BY curr, total_occurences, total_count_views, link_fraction 
HAVING curr LIKE 'Steuart_Smith';
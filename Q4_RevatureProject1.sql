
CREATE TABLE America_Pageviews (
	domain_code STRING,
	page_title STRING,
	count_views INT,
	total_response_size INT)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ' '
	TBLPROPERTIES("skip.header.line.count"="1");
	

LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-140000' INTO TABLE America_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-150000' INTO TABLE America_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-160000' INTO TABLE America_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-170000' INTO TABLE America_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-180000' INTO TABLE America_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-190000' INTO TABLE America_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-200000' INTO TABLE America_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-210000' INTO TABLE America_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-220000' INTO TABLE America_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-230000' INTO TABLE America_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-000000' INTO TABLE America_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-010000' INTO TABLE America_Pageviews;

CREATE TABLE World_Pageviews (
	domain_code STRING,
	page_title STRING,
	count_views INT,
	total_response_size INT)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ' '
	TBLPROPERTIES("skip.header.line.count"="1");
	
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-020000' INTO TABLE World_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-030000' INTO TABLE World_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-040000' INTO TABLE World_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-050000' INTO TABLE World_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-060000' INTO TABLE World_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-070000' INTO TABLE World_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-080000' INTO TABLE World_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-090000' INTO TABLE World_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-100000' INTO TABLE World_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-110000' INTO TABLE World_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-120000' INTO TABLE World_Pageviews;
LOAD DATA INPATH '/user/apesch/dec-pageviews/pageviews-20201201-130000' INTO TABLE World_Pageviews;

CREATE TABLE En_America_Pageviews (
	page_title STRING,
	count_views INT,
	total_response_size INT)
PARTITIONED BY (domain_code STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' '
TBLPROPERTIES("skip.header.line.count"="1");

CREATE TABLE En_World_Pageviews (
	page_title STRING,
	count_views INT,
	total_response_size INT)
PARTITIONED BY (domain_code STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' '
TBLPROPERTIES("skip.header.line.count"="1");

INSERT INTO En_America_Pageviews PARTITION(domain_code = 'en')
SELECT page_title, count_views, total_response_size FROM America_Pageviews WHERE domain_code = 'en';

INSERT INTO En_America_Pageviews PARTITION(domain_code = 'en.m')
SELECT page_title, count_views, total_response_size FROM America_Pageviews WHERE domain_code = 'en.m';


INSERT INTO En_World_Pageviews PARTITION(domain_code = 'en')
SELECT page_title, count_views, total_response_size FROM World_Pageviews WHERE domain_code = 'en';

INSERT INTO En_World_Pageviews PARTITION(domain_code = 'en.m')
SELECT page_title, count_views, total_response_size FROM World_Pageviews WHERE domain_code = 'en.m';

SELECT * FROM En_America_Pageviews;

CREATE VIEW sum_pageviews as
SELECT En_America_Pageviews.page_title, 
SUM(En_America_Pageviews.count_views) AS American_views, 
SUM(En_World_Pageviews.count_views) AS World_views
FROM En_America_Pageviews 
INNER JOIN En_World_Pageviews
	ON (En_America_Pageviews.page_title = En_World_Pageviews.page_title)
GROUP BY En_America_Pageviews.page_title
ORDER BY American_views desc;


CREATE TABLE Pageview_comparison (
	page_title STRING,
	American_views INT,
	World_views INT)
	ROW FORMAT DELIMITED
	FIELDS TERMINATED BY ' '
	TBLPROPERTIES("skip.header.line.count"="1");
	
INSERT INTO Pageview_comparison
SELECT page_title, American_views, World_views FROM sum_pageviews;

--Emma_Portner has 9 million views in america and 15 thousand elsewhere
SELECT * FROM Pageview_comparison
WHERE American_views > (World_views + 200000)
ORDER BY American_views desc;
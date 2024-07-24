--- 1. Chuyển đổi kiểu dữ liệu phù hợp cho các trường
ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN ordernumber TYPE integer USING (trim(ordernumber)::integer);
ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN quantityordered TYPE integer USING (trim(quantityordered)::integer);
ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN priceeach TYPE decimal USING (trim(priceeach)::decimal);
ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN orderlinenumber TYPE integer USING (trim(orderlinenumber)::integer);
ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN sales TYPE decimal USING (trim(sales)::decimal);
ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN msrp TYPE numeric USING (trim(msrp)::numeric);
	--- Không hiểu :)
SET datestyle = 'iso,mdy'; 
ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN orderdate TYPE timestamp 
	USING (trim(orderdate)::timestamp);

--- 2. Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
SELECT * FROM SALES_DATASET_RFM_PRJ
WHERE ORDERNUMBER IS NULL 
	OR QUANTITYORDERED IS NULL 
	OR PRICEEACH IS NULL 
	OR ORDERLINENUMBER IS NULL 
	OR SALES IS NULL 
	OR ORDERDATE IS NULL

/* 3. Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME. 
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng 
chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường */
	--- ADD cột
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD CONTACTLASTNAME varchar(255),
ADD CONTACTFIRSTNAME varchar(255);
	--- update data
UPDATE SALES_DATASET_RFM_PRJ
SET CONTACTLASTNAME = right(contactfullname, -position ('-' in contactfullname)),
	CONTACTFIRSTNAME = left(contactfullname, position ('-' in contactfullname) -1)
	--- Chữ đầu viết thường
UPDATE SALES_DATASET_RFM_PRJ
SET CONTACTLASTNAME = UPPER(LEFT(CONTACTLASTNAME,1)) || RIGHT(CONTACTLASTNAME,-1),
	CONTACTFIRSTNAME = UPPER(LEFT(CONTACTFIRSTNAME,1)) || RIGHT(CONTACTFIRSTNAME,-1)

--- 4. Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 

	
	--- Thêm cột đang sai nha <3
ALTER TABLE SALES_DATASET_RFM_PRJ
	ADD QTR_ID numeric,
	ADD MONTH_ID numeric,
	ADD YEAR_ID numeric;
	--- Update data
UPDATE SALES_DATASET_RFM_PRJ
	SET QTR_ID = EXTRACT(QUARTER FROM ORDERDATE),
	MONTH_ID = EXTRACT(MONTH FROM ORDERDATE),
	YEAR_ID = EXTRACT(YEAR FROM ORDERDATE);

--- 5.Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và chọn cách xử lý (2 cách)
	--- Sử dụng boxplot
with cte_min_max as (
select Q1 - 1.5*IQR as min_value,
	Q3 + 1.5*IQR as max_value
	from(
	select 
		percentile_cont (0.25) within group(order by QUANTITYORDERED) as Q1,
		percentile_cont (0.75) within group(order by QUANTITYORDERED) as Q3,
		percentile_cont (0.75) within group(order by QUANTITYORDERED) - percentile_cont (0.25) within group(order by QUANTITYORDERED) as IQR
	from SALES_DATASET_RFM_PRJ
)),
	--- xử lý bằng cách set = trung bình
 cte_outliner as (
select * from SALES_DATASET_RFM_PRJ
where QUANTITYORDERED > (select max_value from cte_min_max) 
	or QUANTITYORDERED < (select min_value from cte_min_max) 
)
update SALES_DATASET_RFM_PRJ
set QUANTITYORDERED = avg(QUANTITYORDERED)
  where QUANTITYORDERED in (select QUANTITYORDERED from cte_outliner)
	--- Sử dụng Z-score
with cte_mean_std as (
	select QUANTITYORDERED,
		(select 
		avg(QUANTITYORDERED) from SALES_DATASET_RFM_PRJ) as mean, 
		(select 
		stddev(QUANTITYORDERED) from SALES_DATASET_RFM_PRJ)as std
		from SALES_DATASET_RFM_PRJ
)
select QUANTITYORDERED from cte_mean_std
where abs((QUANTITYORDERED-mean)/std) >3 --- Delete các dòng có QUANTITYORDERED in abs((QUANTITYORDERED-mean)/std) >3
  --- Xử lý bằng cách xóa
delete from SALES_DATASET_RFM_PRJ
where SALES_DATASET_RFM_PRJ in (
  select QUANTITYORDERED from cte_mean_std
where abs((QUANTITYORDERED-mean)/std) >3
)
--- 6. Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN
create table SALES_DATASET_RFM_PRJ_CLEAN as (
  select * from SALES_DATASET_RFM_PRJ
)






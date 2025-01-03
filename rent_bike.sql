
SET GLOBAL local_infile=1;

SHOW VARIABLES LIKE 'local_infile';



show databases;
create database jsdb;

show databases;
use jsdb;

# 이용데이터 테이블 
create table rent_bic(
bike_id varchar(20),
rent_dt varchar(100),
rent_id varchar(20),
rent_nm varchar(100),
rent_hold varchar(20),
rtn_dt varchar(100),
rtn_id varchar(20),
rtn_nm varchar(100),
rtn_hold varchar(20),
use_min varchar(20),
use_dst varchar(20),
birth_year varchar(20),
sex_cd varchar(20),
usr_cls_cd varchar(20),
rent_station_id varchar(20),
rtn_station_id varchar(20),
bike_se_cd varchar(20));

drop table rent_bic;

LOAD DATA LOCAL INFILE 'C:/Users/user/Desktop/portfolio/rent_bike/rental_2312.csv'
INTO TABLE rent_bic
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from rent_bic;


# rent_id와 rtn_id 통일
SET SQL_SAFE_UPDATES = 0;

UPDATE rent_bic SET rent_id = LPAD(rent_id, 5, '0');

select * from rent_bic;





# 대여소 정보 테이블
create table rent_area(
rent_no varchar(20),
rent_nm varchar(20),
sta_add1 varchar(20),
sta_add2 varchar(100),
sta_lat varchar(20),
sta_long varchar(20),
ins_dt varchar(20),
lcd varchar(20),
qr varchar(20),
sty varchar(20));

drop table rent_area;

LOAD DATA LOCAL INFILE 'C:/Users/user/Desktop/portfolio/rent_bike/area_2312.csv'
INTO TABLE rent_area
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from rent_area;


UPDATE rent_area SET rent_no = LPAD(rent_no, 5, '0');

select * from rent_area;




--

select count(*) from rent_bic;
select count(*) from rent_area;



select * from rent_bic;

select * from rent_area;

select * from rent_bic order by rtn_id;


select 
	count(case when bike_id is null then 1 end),
	count(case when rent_dt is null then 1 end),
	count(case when rent_id is null then 1 end),
	count(case when rent_nm is null then 1 end),
	count(case when rent_hold is null then 1 end),
	count(case when rtn_dt is null then 1 end),
	count(case when rtn_id is null then 1 end),
	count(case when rtn_nm is null then 1 end),
	count(case when rtn_hold is null then 1 end),
	count(case when use_min is null then 1 end),
	count(case when use_dst is null then 1 end),
	count(case when birth_year is null then 1 end),
	count(case when sex_cd is null then 1 end),
	count(case when usr_cls_cd is null then 1 end),
	count(case when rent_station_id is null then 1 end),
	count(case when rtn_station_id is null then 1 end),
	count(case when bike_se_cd is null then 1 end)	
from rent_bic;



-- begin;
-- rollback;

select * from rent_bic where rent_dt is null;

delete from rent_bic where rent_dt is null;


select * from rent_bic order by rtn_id desc;

# rtn_id 9146개

select * from rent_bic where rtn_id is null;
# 문의 결과 강제 반납 처리된 데이터이다.
# 강제반납 : 이용자가 실수로 완전히 반납잠금을 체결하지 않아, 초과요금이 불의로 발생하고 있는 경우 시스템팀에서 임의로 강제반납처리를 해주고 있습니다.

update rent_bic set rtn_id = coalesce(rtn_id,'99999');
update rent_bic set rtn_nm = coalesce(rtn_nm,'강제반납');
update rent_bic set rtn_station_id = coalesce(rtn_station_id,'강제반납');

select * from rent_bic where rtn_hold is null;
-- update rent_bic set rtn_hold = coalesce(rtn_hold,'강제반납');
# rtn_hold는 신경 쓰지 말자. area에 qr인지 lcd인지 나와서 상관 없을 듯

select * from rent_bic where rtn_station_id is null AND rtn_id is not null;



select * from rent_bic where use_dst is null;
# 이수센터로 가는 데이터 중 문제가 생겨서 밀림
# 다 필요 없어서 삭제
delete from rent_bic where use_dst is null;


-- hold 제거
alter table rent_bic drop column rent_hold;
alter table rent_bic drop column rtn_hold;

select * from rent_bic;

# 갑자기 드는 의문 현업에서는 사용량 데이터가 있지만 성별이나 나이 등 고객 데이터에 null값이 있는 경우 다 버리는지 아니면 사용량 데이터만 살리는지 사용량을 볼 때와 고객을 볼 때 나눠서 데이터를 가시화하는지 궁금하다.
# 적으면서 든 생각인데 기타로 빼서 하는 건 어떨까? 아 근데 그냥 데이터를 어떻게 볼 지에 따라 다를 거 같다. 예를 들어 자전거 사용량에 따른 교체 시기를 알아보기 위해 자전거 한 대를 추적한다고 가정하면 고객 데이터가 따로 필요 없으니까.
# 근데 타겟 분석으로 마케팅에 활용하기 위해서는 고객 데이터가 필수니까 null값을 버려야 좋은 데이터가 되지 않을까 싶다.


select 
	count(case when bike_id is null then 1 end),
	count(case when rent_dt is null then 1 end),
	count(case when rent_id is null then 1 end),
	count(case when rent_nm is null then 1 end),
	count(case when rtn_dt is null then 1 end),
	count(case when rtn_id is null then 1 end),
	count(case when rtn_nm is null then 1 end),
	count(case when use_min is null then 1 end),
	count(case when use_dst is null then 1 end),
	count(case when birth_year is null then 1 end),
	count(case when sex_cd is null then 1 end),
	count(case when usr_cls_cd is null then 1 end),
	count(case when rent_station_id is null then 1 end),
	count(case when rtn_station_id is null then 1 end),
	count(case when bike_se_cd is null then 1 end)	
from rent_bic;


select count(1) from rent_bic where birth_year is null and sex_cd is null;
-- 35,281개

select count(1) from rent_bic where birth_year is null;
-- 145,988개 (6.7%)
update rent_bic set birth_year = coalesce(birth_year,'unknown');

select count(1) from rent_bic where sex_cd is null;
-- 557,538개 (25.6%)
update rent_bic set sex_cd = coalesce(sex_cd,'unknown');

select * from rent_bic;


# as 맡긴
select count(distinct bike_id) as_bike from rent_bic where rent_nm like '%as%' or rtn_nm like '%as%' or rent_nm like '상암센터' or rtn_nm like '상암센터' or rent_nm like '천왕센터' or rtn_nm like '천왕센터'
or rent_nm like '개화센터' or rtn_nm like '개화센터' or rent_nm like '%영남%' or rtn_nm like '%영남%' or rent_nm like '중랑센터' or rtn_nm like '중랑센터';
-- as 자전거 120개

select * from rent_bic where rent_nm like '%as%' or rtn_nm like '%as%' or rent_nm like '상암센터' or rtn_nm like '상암센터' or rent_nm like '천왕센터' or rtn_nm like '천왕센터'
or rent_nm like '개화센터' or rtn_nm like '개화센터' or rent_nm like '%영남%' or rtn_nm like '%영남%' or rent_nm like '중랑센터' or rtn_nm like '중랑센터';


# 전체 자전거 36,407개
SELECT COUNT(DISTINCT bike_id) from rent_bic;


create table rent_merge as 
with a as (select a.bike_id, a.rent_dt, a.rent_id, a.rent_nm, a.rtn_dt, a.rtn_id, a.rtn_nm, a.use_min, a.use_dst, 
		   a.birth_year, a.sex_cd, a.usr_cls_cd, a.rent_station_id, a.rtn_station_id, a.bike_se_cd, b.sta_add1 rent_add1, 
           b.sta_add2 rent_add2, b.ins_dt rent_ins_dt, b.lcd rent_lcd, b.qr rent_qr, b.sty rent_sty
           from rent_bic a left join rent_area b on a.rent_id=b.rent_no)
select a.bike_id, a.rent_dt, a.rent_id, a.rent_nm, a.rtn_dt, a.rtn_id, a.rtn_nm, a.use_min, a.use_dst, a.birth_year, a.sex_cd, a.usr_cls_cd, a.rent_station_id, a.rtn_station_id, 
a.bike_se_cd, a.rent_add1, a.rent_add2, a.rent_ins_dt, a.rent_lcd, a.rent_qr, a.rent_sty, 
b.sta_add1 rtn_add1, b.sta_add2 rtn_add2, b.ins_dt rtn_ins_dt, b.lcd rtn_lcd, b.qr rtn_qr, b.sty rtn_sty from a left join rent_area b on a.rtn_id=b.rent_no;

select 'bike_id','rent_dt','rent_id','rent_nm','rtn_dt','rtn_id','rtn_nm','use_min','use_dst','birth_year','sex_cd','usr_cls_cd','rent_station_id','rtn_station_id',
	   'bike_se_cd','rent_add1','rent_add2','rent_ins_dt','rent_lcd','rent_qr','rent_sty','rtn_add1','rtn_add2','rtn_ins_dt','rtn_lcd','rtn_qr','rtn_sty'
union all
select * from rent_merge INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/rent_merge4.csv' FIELDS TERMINATED BY '|' ENCLOSED BY '"'  LINES TERMINATED BY '\n';

SHOW VARIABLES LIKE 'secure_file_priv';

select * from rent_merge;

select rent_add1, count(1) cnt from rent_merge group by rent_add1 order by 2 desc;
select rtn_add1, count(1) cnt from rent_merge group by rtn_add1 order by 2 desc;


select count(1) from rent_merge;
-- 2,176,195개

select count(1) from rent_merge where rent_add1 = rtn_add1;
-- 1,693,834개 (77.8%)

select count(1) from rent_merge where rent_add1 != rtn_add1;
-- 472,332개 (21.7%)

select * from rent_merge order by rent_add1 desc;

# 강제반납 된 거
select count(1) from rent_merge where rtn_id = 99999;
-- 9,146개

select count(1) from rent_merge where rtn_id = 99999;
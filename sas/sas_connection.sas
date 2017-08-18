
-- Connection to Teradata


%let cdmid = xxxx;
%let pass = 'xxxx';
%let server = "td-cdm-p-";
%let schema = xxxx;
/* %let database = xxxx; */

libname cdm teradata user=&cdmid. pass=&pass. server= 'td-cdm-p-' schema=xxxx;



proc sql;
connect to teradata (user=&cdmid. pass=&pass. server="td-cdm-p-" ) ;
	create table work.sba_cdm_orders as 
	select *
	from connection to teradata
		(
		select ord.ord_nmb
		, cflt.src_orgn_dstr_cd as div
		, ord.src_mstr_cust_nmb
		, trim(leading from (TRIM (TRAILING '.' FROM CAST(ord.mstr_cust_ky AS DECIMAL(32,0))))) AS mstr_cust_ky
		, case when ord.src_sls_ord_mth_cd = 'Z' then 'mobile' else 'desktop' end as "domain"
		, cflt.frst_ord_tms
		,ord.ord_tms
		,cast(ord.ord_tms as date) as ord_dt
		,ord.sls_ord_tot_amt as ordered_amt
		,ord.sls_ord_tot_ship_amt as shipped_amt
		,min(shp.end_of_day_postd_tms) as ship_tms
		from Prd_contr_dmv.f_sls_ord_v ord
		inner join Prd_contr_dmv.d_cust_flat_v cflt
		on ord.mstr_cust_ky = cflt.cust_ky
		left join Prd_contr_dmv.f_ship_ln_v shp
		on ord.ord_nmb = shp.ord_nmb
		where cflt.cust_lvl='MASTER'
		and ord.ord_vrsn_seq_nmb = '0'
		and cast(ord.ord_tms as date) between (date'2017-08-06' - 90) and '2017-08-12'  
		and ordered_amt > 0  
		group by 1,2,3,4,5,6,7,8,9,10
		;
		) b	;
disconnect from teradata;
quit;





-- Connection to SQL server


/*Libname cj odbc  user=lliu pw=om$lljan31  dsn='cookiejar' qualifier='user_ll' schema='dbo';*/
libname FOC odbc user=&cjid. password=&cjpw. dsn="FOC" schema=user_ss2;




-- Connection to Oracle

options compress=yes ls=132 ps=80 obs=max ls=256 ps=500 mlogic mprint symbolgen source source2 sortsize=max sortpgm=best sortanom=btv
		sortcut=100000 sortcutp=10m nocenter;

%let username_mdm = xxxx;
%let password_mdm = 'xxxx'; 
%let path_mdm = EQUIFAXMDMDB;

libname mdm oracle username=&username_mdm password=&password_mdm path=&path_mdm;



%let username_sa = sa_admin;
%let password_sa = 'xxxx'; 
%let path_sa = somen;

libname sa oracle  username=&username_sa  password=&password_sa  path=&path_sa;






%let ora_pdsrpt=user='xxx' password='xxx' path='PDSRPT.WORLD';

libname pdsrpt oracle &ora_pdsrpt;

proc sql; 
connect to oracle(&ora_pdsrpt); 
create table test_pdsrpt as 
select * from connection to oracle
(select * from ods.oes_ord_num_xref_eop where rownum < 10 ); 
disconnect from oracle;
quit; 





-- Connection to Hadoop


options set=SAS_HADOOP_CONFIG_PATH="/opt/sas/hadoop_bn/conf";
options set=SAS_HADOOP_JAR_PATH="/opt/sas/hadoop_bn/lib";

libname hddlib hadoop server=hadop_server schema=YourDB password= ******;

/* PROD - Blue Mercury (Dev) - Sample libref connection to HiveServer2 (default): */

libname hdplib hadoop server=haddop_server  user=mephamj password= ******;

/* PROD  Sample PROC SQL connection: */

proc sql;
connect to hadoop (server=Hadoop_server user=mephamj password=************);

e.g. 
proc sql;
	connect to hadoop (server=lhdppn00p02  user=mephamj password=***********);
	create table mydata.Mytable as
		select * from connection to hadoop
			(
		select  xyx
			rom db.Table_name
			where 
				dt between '2016-05-01' and '2016-05-02'
			order by xyz
			);
	disconnect from hadoop;
quit;


-- convert decimal to string

 trim(leading (TRIM (TRAILING '.' FROM CAST(ord.mstr_cust_ky AS DECIMAL(32,0))))) AS mstr_cust_ky
  


-- cast timestamp to date
 
 cast(ord.ord_tms as date) between '2017-01-01' and '2017-01-01' 



-- concatenate
 
 ship_pstl_cd_pre||substr(ship_pstl_cd_sfx,1,2) as zip_code

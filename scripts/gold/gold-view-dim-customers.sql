create or alter view gold.dim_customers as 
SELECT 
    row_number() over(order by ci.cst_id) as customer_key,
    ci.cst_id as customer_id,
    ci.cst_key as csutomer_number,
    ci.cst_firstname as first_name,
    ci.cst_lastname as last_name,
    case 
        when trim(lower(ci.cst_gnder)) != 'n/a' then cst_gnder
        else coalesce(ca.gen, 'n/a')
    end as gender,
    ci.cst_marital_status as marital_status,
    ca.bdate as birthdate,
    la.cntry as country,
    ci.cst_create_date as create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
    ON UPPER(ci.cst_key) = UPPER(ca.cid)
LEFT JOIN silver.erp_loc_a101 AS la
    ON UPPER(ci.cst_key) = UPPER(la.cid)





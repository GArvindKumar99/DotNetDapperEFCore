DROP VIEW IF EXISTS [GSTR1SalesReturnReportView];
create view IF NOT EXISTS GSTR1SalesReturnReportView
AS
SELECT 
ROW_NUMBER () OVER () RowNum,
C.gstin as GSTIN,
C.name as CUSTOMER_NAME,
I.id as INVOICE_NUMBER,
I.createdAt as INVOICE_DATE,
IFNULL(ROUND(I.netAmount / 100.0, 2), 0) as INVOICE_VALUE,
II.igstRate as TOTAL_TAX_PERC,
IFNULL(ROUND(II.totalAmount / 100.0, 2), 0) as TOTAL_AMT,
(IFNULL(ROUND((II.TOTALAMOUNT) / 100.0, 2), 0) - (IFNULL(ROUND((igstAmount) / 100.0, 2), 0) +IFNULL(ROUND((SGSTAMOUNT) / 100.0, 2), 0) + IFNULL(ROUND((CGSTAMOUNT) / 100.0, 2), 0) + IFNULL(ROUND((CESSAMOUNT) / 100.0, 2), 0) + IFNULL(ROUND((ADDITIONALCESSAMOUNT) / 100.0, 2), 0) + (I.TOTALAMOUNT * I.TOTALDISCOUNT / (I.NETAMOUNT + I.TOTALSAVINGS + I.TOTALDISCOUNT)) / 100.0)) 
   AS TAXABLEVALUE,
IFNULL(ROUND(II.cgstAmount / 100.0, 2), 0)  as CGSTAMOUNT,
IFNULL(ROUND(II.sgstAmount / 100.0, 2), 0)  as SGSTAMOUNT,
IFNULL(ROUND(II.igstAmount / 100.0, 2), 0)  as IGSTAMOUNT,
IFNULL(ROUND(II.cessAmount / 100.0, 2), 0)  as CESSAMOUNT,
IFNULL(ROUND(II.additionalcessAmount / 100.0, 2), 0)  as ADDITIONALCESSAMOUNT,
IFNULL(ROUND((II.igstAmount + II.sgstAmount + II.cgstAmount+ II.cessAmount + II.additionalcessAmount) / 100.0, 2), 0) as TOTAL_TAX,
I.isMemo as ISMEMO
from (customers C join Invoices I on C.phone=I.customerphone) J 
JOIN
Items II on I.id =II.invoiceId
where I.totalAmount<0 and I.isdeleted==0

UNION

SELECT 
ROW_NUMBER () OVER () RowNum,
'' as GSTIN,
'' as CUSTOMER_NAME,
I.id as INVOICE_NUMBER,
I.createdAt as INVOICE_DATE,
IFNULL(ROUND(I.netAmount / 100.0, 2), 0) as INVOICE_VALUE,
II.igstRate as TOTAL_TAX_PERC,
IFNULL(ROUND(II.totalAmount / 100.0, 2), 0) as TOTAL_AMT,
(IFNULL(ROUND((II.TOTALAMOUNT) / 100.0, 2), 0) - (IFNULL(ROUND((igstAmount) / 100.0, 2), 0) +IFNULL(ROUND((SGSTAMOUNT) / 100.0, 2), 0) + IFNULL(ROUND((CGSTAMOUNT) / 100.0, 2), 0) + IFNULL(ROUND((CESSAMOUNT) / 100.0, 2), 0) + IFNULL(ROUND((ADDITIONALCESSAMOUNT) / 100.0, 2), 0) + (I.TOTALAMOUNT * I.TOTALDISCOUNT / (I.NETAMOUNT + I.TOTALSAVINGS + I.TOTALDISCOUNT)) / 100.0)) 
   AS TAXABLEVALUE,
IFNULL(ROUND(II.cgstAmount / 100.0, 2), 0)  as CGSTAMOUNT,
IFNULL(ROUND(II.sgstAmount / 100.0, 2), 0)  as SGSTAMOUNT,
IFNULL(ROUND(II.igstAmount / 100.0, 2), 0)  as IGSTAMOUNT,
IFNULL(ROUND(II.cessAmount / 100.0, 2), 0)  as CESSAMOUNT,
IFNULL(ROUND(II.additionalcessAmount / 100.0, 2), 0)  as ADDITIONALCESSAMOUNT,
IFNULL(ROUND((II.igstAmount + II.sgstAmount + II.cgstAmount+ II.cessAmount + II.additionalcessAmount) / 100.0, 2), 0) as TOTAL_TAX,
I.isMemo as ISMEMO
from Invoices I JOIN Items II on I.id =II.invoiceId
where I.totalAmount<0 and I.isdeleted==0 and I.customerPhone is NULL

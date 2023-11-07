DROP VIEW IF EXISTS [GSTR2PurchasesReportView];
create view IF NOT EXISTS GSTR2PurchasesReportView
AS
SELECT 
ROW_NUMBER () OVER () RowNum,
C.gstin as GSTIN,
C.name as DISTRIBUTOR_NAME, 
I.distributorInvoiceNo as INVOICE_NUMBER,
I.createdAt as INVOICE_DATE,
IFNULL(ROUND(I.netAmount / 100.0, 2), 0) as INVOICE_VALUE,
II.igstRate as TOTAL_TAX_PERC,
IFNULL(ROUND(II.totalAmount / 100.0, 2), 0) as TOTAL_AMT,
CASE
      WHEN
         I.ISPRICEEXCLUSIVE = 0
      THEN	  
(IFNULL(ROUND((II.TOTALAMOUNT) / 100.0, 2), 0) - (IFNULL(ROUND((igstAmount) / 100.0, 2), 0) +IFNULL(ROUND((SGSTAMOUNT) / 100.0, 2), 0) + IFNULL(ROUND((CGSTAMOUNT) / 100.0, 2), 0) + IFNULL(ROUND((CESSAMOUNT) / 100.0, 2), 0) + IFNULL(ROUND((ADDITIONALCESSAMOUNT) / 100.0, 2), 0) + (I.TOTALAMOUNT * I.TOTALDISCOUNT / (I.NETAMOUNT + + I.TOTALDISCOUNT)) / 100.0)) 
  WHEN
	  I.ISPRICEEXCLUSIVE = 1 
      THEN	  
         IFNULL(ROUND(ABS(II.TOTALAMOUNT) / 100.0, 2), 0) - IFNULL(ROUND(ABS(II.BILLITEMSPLITDISCOUNT) / 100.0, 2), 0) 
      END   
AS TAXABLEVALUE,
IFNULL(ROUND(II.cgstAmount / 100.0, 2), 0)  as CGSTAMOUNT,
IFNULL(ROUND(II.sgstAmount / 100.0, 2), 0)  as SGSTAMOUNT,
IFNULL(ROUND(II.igstAmount / 100.0, 2), 0)  as IGSTAMOUNT,
IFNULL(ROUND(II.cessAmount / 100.0, 2), 0)  as CESSAMOUNT,
IFNULL(ROUND(II.additionalcessAmount / 100.0, 2), 0)  as ADDITIONALCESSAMOUNT,
IFNULL(ROUND((II.igstAmount + II.sgstAmount + II.cgstAmount+ II.cessAmount + II.additionalcessAmount) / 100.0, 2), 0) as TOTAL_TAX,
I.isMemo as ISMEMO
from (Distributors C join PurchaseOrders I on C.phone=I.distributorPhone) J 
JOIN
PurchaseOrderDetails II on I.id =II.poNumber
where isReturn=false
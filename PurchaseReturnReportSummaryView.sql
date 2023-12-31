﻿DROP VIEW IF EXISTS [PurchaseReturnReportSummaryView];
create view IF NOT EXISTS PurchaseReturnReportSummaryView
AS 
SELECT
   orderDate,
   ISMEMO,
   DISTRIBUTORPHONE,
   I.id, 
   
sum(CASE
      WHEN
         I.ISPRICEEXCLUSIVE = 0
      THEN	  
(IFNULL(ROUND((II.TOTALAMOUNT) / 100.0, 2), 0) - (IFNULL(ROUND((igstAmount) / 100.0, 2), 0) +IFNULL(ROUND((SGSTAMOUNT) / 100.0, 2), 0) + IFNULL(ROUND((CGSTAMOUNT) / 100.0, 2), 0) + IFNULL(ROUND((CESSAMOUNT) / 100.0, 2), 0) + IFNULL(ROUND((ADDITIONALCESSAMOUNT) / 100.0, 2), 0) + (I.TOTALAMOUNT * I.TOTALDISCOUNT / (I.NETAMOUNT + + I.TOTALDISCOUNT)) / 100.0)) 
  WHEN
	  I.ISPRICEEXCLUSIVE = 1 
      THEN	  
         IFNULL(ROUND(ABS(II.TOTALAMOUNT) / 100.0, 2), 0) - IFNULL(ROUND(ABS(II.BILLITEMSPLITDISCOUNT) / 100.0, 2), 0) 
      END) AS TOTALTAXAMOUNT,
   (ROUND(IFNULL(CAST(TOTALSGSTAMOUNT as FLOAT) / 100,0),2)) AS TOTALSGST,
   (ROUND(IFNULL(CAST(TOTALCGSTAMOUNT as FLOAT) / 100,0),2)) AS TOTALCGST,
   (ROUND(IFNULL(CAST(TOTALIGSTAMOUNT as FLOAT) / 100,0),2)) AS TOTALIGST,
   (ROUND(IFNULL(CAST(TOTALCESSAMOUNT as FLOAT) / 100,0),2)) AS TOTALCESS,
   (ROUND(IFNULL(CAST(TOTALADDITIONALCESSAMOUNT as FLOAT) / 100,0),2)) AS TOTALADDITIONALCESS,
    IFNULL(ROUND(totalDiscount / 100.0, 2), 0) as TOTALDISCOUNT,
   IFNULL(ROUND(netAmount / 100.0, 2), 0) as TOTALINVOICEVALUE,
   IFNULL(CAST(deliveryCharges as FLOAT) / 100,0) AS TOTALDELIVERYCHARGES
FROM
   PuRCHASEORDERS  I JOIN
PurchaseOrderDetails II on I.id =II.poNumber
WHERE
   ISDELETED = 0 and isReturn=1
   group by I.id 
   ORDER by orderDate desc
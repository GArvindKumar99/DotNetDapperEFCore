DROP VIEW IF EXISTS [GSTR3BOutwardNonZeroGSTView];
create view IF NOT EXISTS GSTR3BOutwardNonZeroGSTView
AS
select
   ISMEMO,
   Invoices.createdAt,
   ROUND((IFNULL(ROUND((Invoices.totalAmount - totalSavings) / 100.0, 2), 0)), 2) - ROUND((IFNULL(ROUND(TOTALIGSTAMOUNT / 100.0, 2), 0)), 2) - ROUND((IFNULL(ROUND(TOTALSGSTAMOUNT / 100.0, 2), 0)), 2) - ROUND((IFNULL(ROUND(TOTALCGSTAMOUNT / 100.0, 2), 0)), 2) - ROUND((IFNULL(ROUND(totalCessAmount / 100.0, 2), 0)), 2) - ROUND((IFNULL(ROUND(totalAdditionalCessAmount / 100.0, 2), 0)), 2) AS TAXABLEVALUE,
   SUM(IFNULL(SGSTAMOUNT, 0)) / 100.0 AS TOTALSGST,
   SUM(IFNULL(CGSTAMOUNT, 0) ) / 100.0 AS TOTALCGST,
   SUM(IFNULL(IGSTAMOUNT, 0) ) / 100.0 AS TOTALIGST,
   SUM(IFNULL(CESSAMOUNT, 0) ) / 100.0 AS TOTALCESS,
   SUM(IFNULL(ADDITIONALCESSAMOUNT, 0) ) / 100.0 AS TOTALADDITIONALCESS,
   '' as SupplyType
FROM
   Invoices,
   Items 
WHERE
   Invoices.id = Items.INVOICEID 
   AND Invoices.iSDELETED = 0 
   AND 
   (
      Items.IGSTRATE != 0 
      OR 
      (
         Items.cgstRate != 0 
         AND Items.sgstRate != 0 
      )
   )
GROUP BY
   Invoices.createdAt
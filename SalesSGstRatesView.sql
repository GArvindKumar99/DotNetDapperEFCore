create view IF NOT EXISTS SalesSGstRatesView 
AS 

SELECT
   ITEMS.SGSTRATE *2 as GSTRATES , Items.createdAt
FROM
   ITEMS 
WHERE
   ITEMS.sgstAmount >=0 and ITEMS.igstAmount=0
   AND ITEMS.INVOICEID IN 
   (
      SELECT
         INVOICES.id 
      FROM
         INVOICES 
      WHERE
         INVOICES.ISMEMO = 0 
         AND INVOICES.ISGST = 1 
         AND INVOICES.ISDELETED = 0 
          
   )   ORDER by GSTRATES
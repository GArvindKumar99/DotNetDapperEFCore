create view IF NOT EXISTS SalesIGstRatesView 
AS 

SELECT
   ITEMS.IGSTRATE as GSTRATES , Items.createdAt
FROM
   ITEMS 
WHERE
   ITEMS.igstAmount >=0 and ITEMS.sgstAmount=0 and ITEMS.cgstAmount=0
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
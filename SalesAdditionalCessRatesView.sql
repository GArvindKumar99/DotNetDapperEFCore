create view IF NOT EXISTS SalesAdditionalCessRatesView 
AS
SELECT
   ITEMS.ADDITIONALCESSRATE AS GSTRATES , Items.createdAt
FROM
   ITEMS 
WHERE
   ITEMS.additionalcessAmount >=0 
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
          
   )
   
   ORDER by GSTRATES
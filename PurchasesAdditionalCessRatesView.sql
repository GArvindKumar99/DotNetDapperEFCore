create view IF NOT EXISTS PurchasesAdditionalCessRatesView 
AS
SELECT
   PurchaseOrderDetails.ADDITIONALCESSRATE AS GSTRATES , PurchaseOrderDetails.createdAt
FROM
   PurchaseOrderDetails 
WHERE
   PurchaseOrderDetails.additionalcessAmount >=0 
   AND PurchaseOrderDetails.poNumber IN 
   (
      SELECT
         PurchaseOrders.id 
      FROM
         PurchaseOrders 
      WHERE
         PurchaseOrders.ISMEMO = 0 
         AND PurchaseOrders.ISGST = 1 
         AND PurchaseOrders.ISDELETED = 0 
          
   )
   
   ORDER by GSTRATES
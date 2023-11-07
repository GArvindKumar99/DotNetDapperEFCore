create view IF NOT EXISTS PurchasesCessRatesView 
AS 

SELECT
   PurchaseOrderDetails.CESSRATE AS GSTRATES , PurchaseOrderDetails.createdAt
FROM
   PurchaseOrderDetails 
WHERE
   PurchaseOrderDetails.cessAmount >=0 
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
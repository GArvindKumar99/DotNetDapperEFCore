create view IF NOT EXISTS PurchasesSGstRatesView 
AS 

 SELECT
   PurchaseOrderDetails.SGSTRATE*2 as GSTRATES , PurchaseOrderDetails.createdAt
FROM
   PurchaseOrderDetails 
WHERE
   PurchaseOrderDetails.sgstAmount >=0 and PurchaseOrderDetails.igstAmount=0
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
          
   )   ORDER by GSTRATES
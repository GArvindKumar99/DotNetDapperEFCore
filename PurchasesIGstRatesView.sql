create view IF NOT EXISTS PurchasesIGstRatesView 
AS 

SELECT
   PurchaseOrderDetails.IGSTRATE as GSTRATES , PurchaseOrderDetails.createdAt
FROM
   PurchaseOrderDetails 
WHERE
   PurchaseOrderDetails.igstAmount >=0 and PurchaseOrderDetails.sgstAmount=0 and PurchaseOrderDetails.cgstAmount=0
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
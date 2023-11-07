DROP VIEW IF EXISTS [GSTR3BInwardGSTView];
create view IF NOT EXISTS GSTR3BInwardGSTView
AS
SELECT
   PurchaseOrders.isMEMO AS ISMEMO,
   PurchaseOrders.createdAt as createdAt,
   0 as TAXABLEVALUE,
   sum(IFNULL(PurchaseOrderDetails.igstAmount, 0)/ 100.0) AS TOTALIGST,
   sum(IFNULL(PurchaseOrderDetails.cgstAmount, 0)/ 100.0 ) AS TOTALCGST,
   sum(IFNULL(PurchaseOrderDetails.sgstAmount, 0)/ 100.0 ) AS TOTALSGST,
   sum(IFNULL(PurchaseOrderDetails.cessAmount, 0)/ 100.0 ) AS TOTALCESS,
   sum(IFNULL(PurchaseOrderDetails.additionalcessAmount, 0)/ 100.0 ) AS TOTALADDITIONALCESS,
      '' as SupplyType
FROM
   PurchaseOrders 
   INNER JOIN
      PurchaseOrderDetails 
      ON PurchaseOrders.id = PurchaseOrderDetails.poNumber 
WHERE
   PurchaseOrders.isDeleted = 0   
GROUP BY
   PurchaseOrders.createdAt 
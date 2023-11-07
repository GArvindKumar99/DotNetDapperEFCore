DROP VIEW IF EXISTS [StockExpiryReportView];
create view IF NOT EXISTS StockExpiryReportView
AS
SELECT
   B.batchId as BATCHID,
   Case When B.userDefinedBarCode ISNULL
   THEN B.barcode 
   ELSE B.userDefinedBarCode
   end as BARCODE,
   IFNULL(B.NAME, " ") as PRODUCTNAME,
   ProductCategories.name AS CATEGORY,
   IFNULL(ROUND(B.PURCHASEPRICE / 100.0, 2), 0) as PURCHASEPRICE,
   round((
   Case
      WHEN
         B.Uom = "G" 
      THEN
         quantity*1.0 / 1000 
      WHEN
         B.uom = "ML" 
      then
         quantity*1.0 / 1000 
      ELSE
         quantity*1.0 
   end
), 2) as QUANTITY,
IFNULL(ROUND(B.PURCHASEPRICE / 100.0, 2), 0)*round((
   Case
      WHEN
         B.Uom = "G" 
      THEN
         quantity*1.0 / 1000 
      WHEN
         B.uom = "ML" 
      then
         quantity*1.0 / 1000 
      ELSE
         quantity*1.0 
   end
), 2) AS STOCKVALUE,
IFNULL(ProductPacks.expDate, 0) as EXPDATE
FROM
   (
      INVENTORY 
      LEFT JOIN
         (
            PRODUCTS 
            LEFT JOIN
               ProductCategories 
               ON Products.categoryId = ProductCategories.id 
         )
         A 
         ON INVENTORY.PRODUCTCODE = A.PRODUCTCODE
   )
   B 
   LEFT JOIN
      ProductPacks 
      on B.batchId = ProductPacks.batchId 
WHERE
   B.PACKSIZE = 1 
   and B.isDeleted = 0 and ProductPacks.expDate<>0 
GROUP by
   B.batchId 
ORDER by
   productName

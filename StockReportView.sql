DROP VIEW IF EXISTS [StockReportView];
create view IF NOT EXISTS StockReportView
AS
SELECT
   Case When T.userDefinedBarCode ISNULL
   THEN T.barcode 
   ELSE T.userDefinedBarCode
   end as BARCODE,
   ProductPacks.batchId as BATCHID,
   IFNULL(T.NAME, " ") as NAME,
   Case When T.Uom = "G" then "KG"
   WHEN T.uom = "ML" then "L"
   when  T.Uom is null then ""
   ELSE T.Uom
   end as UOM,
   round((Case WHEN T.Uom = "G" then Inventory.quantity*1.0/1000
   WHEN T.uom = "ML" then Inventory.quantity*1.0/1000
   ELSE T.quantity*1.0
   end),2) as QUANTITY,
IFNULL(ROUND(ProductPacks.MRP / 100.0, 2), 0) as MRP,
IFNULL(ROUND((ProductPacks.MRP * round((Case WHEN T.Uom = "G" then Inventory.quantity*1.0/1000
   WHEN T.uom = "ML" then Inventory.quantity*1.0/1000
   ELSE T.quantity*1.0
   end),2) ) / 100.0, 2), 0) as TOTALMRP,
   IFNULL(ROUND(ProductPacks.PURCHASEPRICE / 100.0, 2), 0) as PP,
   IFNULL(ROUND((ProductPacks.PURCHASEPRICE*round((Case WHEN T.Uom = "G" then Inventory.quantity*1.0/1000
   WHEN T.uom = "ML" then Inventory.quantity*1.0/1000
   ELSE T.quantity*1.0
   end),2)  )/ 100.0, 2), 0) as TOTALPP,
   IFNULL(T.MINIMUMBASEQUANTITY, 0) as MINIMUMBASEQUANTITY,
   IFNULL(T.REORDERPOINT, 0) as REORDERPOINT,
   T.VATRATE as VATRATE,
   T.SGSTRATE as SGSTRATE,
   T.CGSTRATE as CGSTRATE,
   T.IGSTRATE as IGSTRATE,
   T.CESSRATE as CESSRATE,
   T.ADDITIONALCESSRATE as ADDITIONALCESSRATE,
   IFNULL(ROUND(ProductPacks.SALEPRICE1 / 100.0, 2), 0) as SALEPRICE1,
   IFNULL(ROUND(ProductPacks.SALEPRICE2 / 100.0, 2), 0) as SALEPRICE2,
   IFNULL(ROUND(ProductPacks.SALEPRICE3 / 100.0, 2), 0) as SALEPRICE3,
   IFNULL(T.HSNCODE, " ") as HSNCODE,
     IFNULL(ProductPacks.mfgDate, 0) as MFGDATE,
   IFNULL(ProductPacks.expDate, 0) as EXPDATE
FROM
   (INVENTORY 
   LEFT JOIN
      PRODUCTS 
      ON INVENTORY.PRODUCTCODE = PRODUCTS.PRODUCTCODE) T 
	  LEFT JOIN ProductPacks 
  on T.batchId= ProductPacks.batchId
  WHERE
   ProductPacks.PACKSIZE = 1 
   and T.isDeleted = 0 GROUP by ProductPacks.batchId
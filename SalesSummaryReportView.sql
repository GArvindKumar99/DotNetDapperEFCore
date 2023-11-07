DROP VIEW IF EXISTS [SalesSummaryReportView];
create view IF NOT EXISTS SalesSummaryReportView
AS
select
  DISTINCT(Invoices.createdAt),
  isMemo,
Case When Products.userDefinedBarCode ISNULL
   THEN Products.barcode 
   ELSE Products.userDefinedBarCode
   end as Barcode,
   batchId AS BatchId,
   items.name as ProductName,
   CASE
      WHEN
         items.uom = 'G' 
      THEN
         'KG' 
      WHEN
         items.uom = 'ML' 
      THEN
         'L' 
      ELSE
         items.uom 
   END
   AS UOM,
   CASE
   When 
   Items.categoryId = 0 then 'MISC.'
   ELSE 
   ProductCategories.name end as Category ,
   CASE
      WHEN
         items.uom = 'G' 
         OR items.uom = 'ML' 
      THEN
	  cast(quantity as float)/1000
	  ELSE
	  cast(quantity as float)
	  END
   as Total_Quantity , 
cast(Items.totalAmount as float) / 100 as Total_Sale_Amount
from
   (items, Invoices, ProductCategories) join Products 
      on items.productCode = Products.barcode  
where
   items.invoiceId = Invoices.id 
   and Invoices.isDeleted=0
   and ITEMS.productCode >= 0 
   and (ProductCategories.id = items.categoryId or Items.categoryId = 0)

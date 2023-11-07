DROP VIEW IF EXISTS [HSNOutwardReportView];
create view IF NOT EXISTS HSNOutwardReportView
AS
SELECT
ROW_NUMBER () OVER () RowNum,
  Case When Products.userDefinedBarCode ISNULL
   THEN Products.barcode 
   ELSE Products.userDefinedBarCode
   end as BARCODE,
   items.HSNCODE as HSNCODE,
   IFNULL (Invoices.bILLTOGSTIN, '') as BILLTOGSTIN,
   Invoices.isMemo as ISMEMO,
   IFNULL(items.NAME, '') as PRODUCTNAME,
   Case When items.Uom = "G" then "KG"
   WHEN items.uom = "ML" then "L"
   when  items.Uom is null then ""
   ELSE items.Uom
   end as UOM,
   sum(
   CASE
      WHEN
         items.UOM = 'G' or items.UOM = 'ML' 
      THEN
         items.QUANTITY / 1000.0
      ELSE
         items.QUANTITY  
   END
)  as QUANTITY, 
   round(sum(CASE
      WHEN
         items.BILLITEMDISCOUNT = 0 
      THEN
         IFNULL(ROUND((
         CASE
            WHEN
         items.UOM = 'G' or items.UOM = 'ML' 
            THEN
               items.SALEPRICE * (items.QUANTITY / 1000.0) 
            ELSE
               items.SALEPRICE * items.QUANTITY 
         END
) / 100.0, 2), 0) - (((
         CASE
            WHEN
              items.UOM = 'G' or items.UOM = 'ML'  
            THEN
               items.SALEPRICE * (items.QUANTITY / 1000.0)
            ELSE
               items.SALEPRICE *  items.QUANTITY 
         END
) * Invoices.TOTALDISCOUNT / (Invoices.NETAMOUNT + Invoices.TOTALSAVINGS + Invoices.TOTALDISCOUNT)) / 100.0) 
         ELSE
            IFNULL(ROUND((
            CASE
               WHEN
              items.UOM = 'G' or items.UOM = 'ML'  
               THEN
                  items.SALEPRICE * (items.QUANTITY / 1000.0) 
               ELSE
                  items.SALEPRICE *  items.QUANTITY
            END
) / 100.0, 2), 0) - (IFNULL(ROUND((items.BILLITEMDISCOUNT) / 100.0, 2), 0)) 
   END),2)
   AS TOT, 
      ROUND(SUM(IFNULL(ROUND((Items.totalAmount) / 100.0, 2), 0)),2)-ROUND(SUM(IFNULL(ROUND(igstAmount / 100.0, 2), 0)),2)-ROUND(SUM(IFNULL(ROUND(sgstAmount / 100.0, 2), 0)),2)-ROUND(SUM(IFNULL(ROUND(cgstAmount / 100.0, 2), 0)),2)-ROUND(SUM(IFNULL(ROUND(cessAmount / 100.0, 2), 0)),2)-ROUND(SUM(IFNULL(ROUND(additionalcessAmount / 100.0, 2), 0)),2) AS TAXABLEVALUE,
	
		sum(IFNULL(ROUND(items.IGSTAMOUNT / 100.0, 2), 0)) as IGSTAMOUNT, 
		sum(IFNULL(ROUND(items.CGSTAMOUNT / 100.0, 2), 0)) as CGSTAMOUNT, 
		sum(IFNULL(ROUND(items.SGSTAMOUNT / 100.0, 2), 0)) as SGSTAMOUNT, 
		sum(IFNULL(ROUND(items.CESSAMOUNT / 100.0, 2), 0)) as CESSAMOUNT, 
		sum(IFNULL(ROUND(items.ADDITIONALCESSAMOUNT / 100.0, 2), 0)) as ADDITIONALCESSAMOUNT,
  	INVOICES.createdAt as CREATEDAT
 
FROM
   (INVOICES join items on INVOICES.id=items.invoiceId )join
      Products 
      on items.productCode = Products.barcode 
where invoices.isDeleted=0
group by
   INVOICES.createdAt,items.hsnCode,items.name,items.PRODUCTCODE
ORDER BY
   INVOICES.CREATEDAT desc
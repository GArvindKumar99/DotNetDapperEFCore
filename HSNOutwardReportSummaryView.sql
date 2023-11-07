DROP VIEW IF EXISTS [HSNOutwardReportSummaryView];
create view IF NOT EXISTS HSNOutwardReportSummaryView
AS
SELECT
   cast(a.isMemo as TEXT) as IsMemo,
   a.createdAt as CREATEDAT,
   count (distinct(a.PRODUCTCODE)) as PRODUCTCODE,
   round(IFNULL((NETAMOUNT + deliveryCharges - ifnull(PA.discountapplied, 0)) / 100.0, 0),2) AS TOT,
   round((ifnull(PA.discountApplied, 0) + a.totalDiscount + a.totalSavings)/ 100.0,2) as TOTDISC,
   round(a.deliveryCharges / 100.0,2) AS TOTDEL,
   round((IFNULL((a.totalAmount - totalSavings) / 100.0, 0)) - (IFNULL(TOTALIGSTAMOUNT / 100.0, 0)) - (IFNULL(TOTALSGSTAMOUNT / 100.0, 0)) - (IFNULL(TOTALCGSTAMOUNT / 100.0, 0)) - (IFNULL(totalCessAmount / 100.0, 0)) - (IFNULL(totalAdditionalCessAmount / 100.0, 0)),2) AS TAXABLEVALUE,
   round(SUM(IFNULL(a.IGSTAMOUNT / 100.0, 0)),2) as IGSTAMOUNT,
   round(SUM(IFNULL(a.CGSTAMOUNT / 100.0, 0)),2) as CGSTAMOUNT,
   round(SUM(IFNULL(a.SGSTAMOUNT / 100.0, 0)),2) as SGSTAMOUNT,
   round(SUM(IFNULL(a.CESSAMOUNT / 100.0, 0)),2) as CESSAMOUNT,
   round(SUM(IFNULL(a.ADDITIONALCESSAMOUNT / 100.0, 0)),2) as ADDITIONALCESSAMOUNT 
from
   (
      INVOICES I 
      join
         items II 
         on I.id = II.invoiceId
   )
   a 
   left join
      PromotionsAppliedDetails PA 
      on a.id = PA.invoiceId 
WHERE
   a.isDeleted = 0 
group by
   a.CREATEDAT 
ORDER by
   a.CREATEDAT desc
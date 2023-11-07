DROP VIEW IF EXISTS [SalesSummaryTotalReportView];
create view IF NOT EXISTS SalesSummaryTotalReportView
AS
SELECT 
'' as Description,
invoices.id as InvoiceId, 
II.quantity as Quantity,
sum(totalAmount)/100.0 as Gross, 
(totalDiscount+ ifnull(PA.discountApplied,0)+totalSavings)/100.0 as Discount, 
sum(deliveryCharges/100.0) as DeliveryCharges, 
sum(netAmount-ifnull(PA.discountApplied,0)+deliveryCharges)/100.0 as Net,
abs(invoices.totalAmount-totalSavings-totalDiscount-netAmount)/100.0 as Roundoff, 
isMemo as IsMemo,
invoices.createdAt as CreatedAt
from (Invoices join 
(
SELECT invoiceId,
mrp, 
sum(
CASE
      WHEN
            UOM = 'G' OR UOM = 'ML' 
      THEN
	  	  cast(quantity as float)/1000
	  ELSE
		cast(quantity as float)
	  END
	  ) as quantity
	  from items
	  group by invoiceid
)	  II	  on invoices.id=II.invoiceId)I left join PromotionsAppliedDetails PA on invoices.id = PA.invoiceid
where invoices.isDeleted=0
group by invoices.createdAt
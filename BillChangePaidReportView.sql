DROP VIEW IF EXISTS [BillChangePaidReportView];
create view IF NOT EXISTS BillChangePaidReportView
AS
SELECT
I.id as BillId, 
(I.netAmount-ifnull(PAD.discountApplied,0)+I.deliveryCharges)/100.0 as BillAmount, 
CASE
WHEN
sum(T.amount)>(I.netAmount-ifnull(PAD.discountApplied,0)+I.deliveryCharges)
THEN
(sum(T.amount)-(I.netAmount-ifnull(PAD.discountApplied,0))+I.deliveryCharges)/100.0
ELSE
0
END
as ChangePaid
from (Invoices I left join 
(SELECT invoiceId, paymentMode,
SUM(CASE WHEN paymentType = 'CURRENT' THEN amount ELSE 0 END) - 
SUM(CASE WHEN paymentType = 'ADVANCE' THEN amount ELSE 0 END) AS amount
from Transactions
where paymentMode='CASH'
GROUP BY 
    invoiceid,
    paymentmode) T
on I.id=T.invoiceId) IT
left join PromotionsAppliedDetails PAD on IT.invoiceId=PAD.invoiceId
where I.netAmount>0 and I.isDeleted=0 
GROUP by I.id
UNION
SELECT
I.id as BillId, 
I.netAmount/100.0 as BillAmount,
abs(I.netAmount)/100.0 as ChangePaid
from Invoices I
where I.netAmount<0 and I.isDeleted=0
GROUP by I.id   
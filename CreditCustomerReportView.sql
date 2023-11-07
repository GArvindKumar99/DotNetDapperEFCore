DROP VIEW IF EXISTS [CreditCustomerReportView];
create view IF NOT EXISTS CreditCustomerReportView
AS
SELECT 
 ifnull(A.name,"") as CustomerName,
 ifnull(A.phone,0) as CustomerPhone, 
 ifnull(A.alternatephone,0) as CustomerAltPhone,
 ifnull(round(B.amountDue/100.0,2),0) as AmountDue, 
 ifnull(B.lastPaymentDate,0) as LastPaymentDate, 
 ifnull(round(B.lastPaymentAmount/100.0,2),0) as LastPaymentAmount
from customers A left JOIN customerdetails B on A.phone=B.phone
ORDER by amountDue desc

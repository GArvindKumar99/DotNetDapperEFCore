DROP VIEW IF EXISTS [ProfitAndLossReportHelperView];
create view IF NOT EXISTS ProfitAndLossReportHelperView
AS
SELECT DISTINCT(items.id),items.invoiceId, items.purchasePrice, Items.uom, 
   CASE
      WHEN
         items.uom = 'G' 
      THEN
         	  cast(items.quantity as float)/1000 
      WHEN
         items.uom = 'ML' 
      THEN
         	  cast(items.quantity as float)/1000 
      ELSE
         Items.quantity
   END
   AS qty , Items.igstRate   	   
FROM Items

	   

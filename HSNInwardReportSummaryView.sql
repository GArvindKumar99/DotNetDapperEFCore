﻿create view IF NOT EXISTS HSNInwardReportSummaryView
AS
SELECT
   count (distinct(PuRCHASEORDERDETAILS.PRODUCTCODE)) as PRODUCTCODE,
   CASE
      WHEN
         PuRCHASEORDERS.ISPRICEEXCLUSIVE = 0 
      THEN
         SUM((IFNULL(ROUND((
         CASE
            WHEN
               PuRCHASEORDERDETAILS.UOM = 'G' or PuRCHASEORDERDETAILS.UOM = 'ML'
            THEN
			   PuRCHASEORDERDETAILS.PURCHASEPRICE* (PuRCHASEORDERDETAILS.RECEIVEDQUANTITY / 1000.0) 

            ELSE
			   PuRCHASEORDERDETAILS.PURCHASEPRICE* PuRCHASEORDERDETAILS.RECEIVEDQUANTITY 

         END
) / 100.0, 2), 0)) - IFNULL(ROUND((PuRCHASEORDERDETAILS.BILLITEMSPLITDISCOUNT) / 100.0, 2), 0)) 
         ELSE
            SUM((IFNULL(ROUND((
            CASE
               WHEN
               PuRCHASEORDERDETAILS.UOM = 'G' or PuRCHASEORDERDETAILS.UOM = 'ML'
               THEN
                                    PuRCHASEORDERDETAILS.PURCHASEPRICE * (PuRCHASEORDERDETAILS.RECEIVEDQUANTITY / 1000.0) 

               ELSE
			   				  PurCHASEORDERDETAILS.PURCHASEPRICE * PuRCHASEORDERDETAILS.RECEIVEDQUANTITY 

            END
) / 100.0, 2), 0) + IFNULL(ROUND((PuRCHASEORDERDETAILS.IGSTAMOUNT) / 100.0, 2), IFNULL(ROUND((PuRCHASEORDERDETAILS.SGSTAMOUNT) / 100.0, 2), 0) + IFNULL(ROUND((PuRCHASEORDERDETAILS.CGSTAMOUNT) / 100.0, 2), 0)) + IFNULL(ROUND((PuRCHASEORDERDETAILS.CESSAMOUNT) / 100.0, 2), 0)) + IFNULL(ROUND((PuRCHASEORDERDETAILS.ADDITIONALCESSAMOUNT) / 100.0, 2), 0) - IFNULL(ROUND((PuRCHASEORDERDETAILS.BILLITEMSPLITDISCOUNT) / 100.0, 2), 0)) 
   END
   AS QT, 
   CASE
      WHEN
         PuRCHASEORDERS.ISPRICEEXCLUSIVE = 0 
      THEN
         SUM(IFNULL(ROUND((
         CASE
            WHEN
              PuRCHASEORDERDETAILS.UOM = 'G' or PuRCHASEORDERDETAILS.UOM = 'ML'
               THEN
                                    PuRCHASEORDERDETAILS.PURCHASEPRICE * (PuRCHASEORDERDETAILS.RECEIVEDQUANTITY / 1000.0) 

               ELSE
			   				  PurCHASEORDERDETAILS.PURCHASEPRICE * PuRCHASEORDERDETAILS.RECEIVEDQUANTITY
         END
) / 100.0, 2), 0) - IFNULL(ROUND((PuRCHASEORDERDETAILS.IGSTAMOUNT) / 100.0, 2),0)- IFNULL(ROUND((PuRCHASEORDERDETAILS.SGSTAMOUNT) / 100.0, 2), 0) - IFNULL(ROUND((PuRCHASEORDERDETAILS.CGSTAMOUNT) / 100.0, 2), 0) - IFNULL(ROUND((PurCHASEORDERDETAILS.CESSAMOUNT) / 100.0, 2), 0) - IFNULL(ROUND((PurCHASEORDERDETAILS.ADDITIONALCESSAMOUNT) / 100.0, 2), 0) - IFNULL(ROUND((PuRCHASEORDERDETAILS.BILLITEMSPLITDISCOUNT) / 100.0, 2), 0)) 
         ELSE
            SUM(IFNULL(ROUND((
            CASE
               WHEN
                  PuRCHASEORDERDETAILS.UOM = 'G' or PuRCHASEORDERDETAILS.UOM = 'ML'
               THEN
                                    PuRCHASEORDERDETAILS.PURCHASEPRICE * (PuRCHASEORDERDETAILS.RECEIVEDQUANTITY / 1000.0) 

               ELSE
			   				  PurCHASEORDERDETAILS.PURCHASEPRICE * PuRCHASEORDERDETAILS.RECEIVEDQUANTITY
            END
) / 100.0, 2), 0) - IFNULL(ROUND((PuRCHASEORDERDETAILS.BILLITEMSPLITDISCOUNT) / 100.0, 2), 0)) 
   END
   AS TAXABLEVALUE , SUM(IFNULL(ROUND(PuRCHASEORDERDETAILS.IGSTAMOUNT / 100.0, 2), 0)) as IGSTAMOUNT, SUM(IFNULL(ROUND(PuRCHASEORDERDETAILS.CGSTAMOUNT / 100.0, 2), 0)) as CGSTAMOUNT, SUM(IFNULL(ROUND(PuRCHASEORDERDETAILS.SGSTAMOUNT / 100.0, 2), 0)) as SGSTAMOUNT, SUM(IFNULL(ROUND(PuRCHASEORDERDETAILS.CESSAMOUNT / 100.0, 2), 0)) as CESSAMOUNT , SUM(IFNULL(ROUND(PuRCHASEORDERDETAILS.ADDITIONALCESSAMOUNT / 100.0, 2), 0)) as ADDITIONALCESSAMOUNT,
  PuRCHASEORDERS.isMEMO,
 PuRCHASEORDERS.orderDate as ORDERDATE
FROM
   PuRCHASEORDERS 
   INNER JOIN
      PuRCHASEORDERDETAILS 
      ON pURCHASEORDERS.id = pURCHASEORDERDETAILS.PONUMBER 
WHERE
   pURCHASEORDERS.iSDELETED = 0 
GROUP BY PuRCHASEORDERS.isMemo 
ORDER BY
   IFNULL(PURCHASEORDERS.ORDERDATE, PuRCHASEORDERS.creATEDAT)
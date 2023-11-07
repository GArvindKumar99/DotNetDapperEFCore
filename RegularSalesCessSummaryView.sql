create view IF NOT EXISTS RegularSalesCessSummaryView
AS 
SELECT
   SUM(TOTALAMOUNT - ( (CGSTAMOUNT + SGSTAMOUNT + IGSTAMOUNT) ) - CESSAMOUNT - ADDITIONALCESSAMOUNT - BILLITEMDISCOUNT) AS TOTALTAXAMOUNT,
   SUM(CESSAMOUNT) AS TAXAMOUNT,
   CESSRATE ,
   CREATED_AT
FROM
   (
      SELECT
         ITEMS.TOTALAMOUNT,
         IFNULL(ITEMS.CGSTAMOUNT, 0) as CGSTAMOUNT,
         IFNULL(ITEMS.IGSTAMOUNT, 0) as IGSTAMOUNT,
         IFNULL(ITEMS.SGSTAMOUNT, 0) as SGSTAMOUNT,
         IFNULL(ITEMS.CESSAMOUNT, 0) as CESSAMOUNT,
         IFNULL(ITEMS.ADDITIONALCESSAMOUNT, 0) as ADDITIONALCESSAMOUNT,
         ITEMS.CESSRATE,
         {0} AS BILLITEMDISCOUNT,
		 Invoices.createdAt as CREATED_AT

      FROM
         ITEMS 
         LEFT JOIN
            INVOICES 
            ON ITEMS.INVOICEID = INVOICES.id 
      WHERE
         ITEMS.INVOICEID IN 
         (
            SELECT
               INVOICES.id 
            FROM
               INVOICES 
            WHERE
               INVOICES.ISMEMO = 0 
               AND INVOICES.ISGST = 1 
               AND INVOICES.ISDELETED = 0 
               AND INVOICES.ISUPDATED = 0 
               
         )
         OR ITEMS.INVOICEID IN 
         (
            SELECT
               INVOICES.PARENTMEMOID 
            FROM
               INVOICES 
            WHERE
               INVOICES.ISMEMO = 0 
               AND INVOICES.ISDELETED = 0 
               AND INVOICES.ISGST = 1 
               AND INVOICES.ISUPDATED = 0 
               
         )
   )
GROUP BY
   CESSRATE 
ORDER BY
   CESSRATE
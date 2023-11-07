DROP VIEW IF EXISTS [SalesRegisterReportDetailsView];
create view IF NOT EXISTS SalesRegisterReportDetailsView
AS 
SELECT
    ROW_NUMBER () OVER () RowNum,
    IFNULL(A.bILLTOGSTIN, '') AS BILLTOGSTIN,
    IFNULL(a.NAME, '') AS NAME,
    a.id AS ID,
    a.ISMEMO AS ISMEMO,
    a.CREATEDAT AS CREATEDAT,
    IFNULL(ROUND((a.NETAMOUNT - IFNULL(PA.discountapplied, 0) + deliveryCharges) / 100.0, 2), 0) AS INVOICEVALUE,
    IFNULL(a.HSNCODE, '') AS HSN,
    IFNULL(a.NAME, '') AS PRODUCTNAME,
    a.QUANTITY AS QUANTITY,
    (
        IFNULL(ROUND((TOTALAMOUNT) / 100.0, 2), 0) -
        (
            IFNULL(ROUND((igstAmount) / 100.0, 2), 0) +
            IFNULL(ROUND((SGSTAMOUNT) / 100.0, 2), 0) +
            IFNULL(ROUND((CGSTAMOUNT) / 100.0, 2), 0) +
            IFNULL(ROUND((a.CESSAMOUNT) / 100.0, 2), 0) +
            IFNULL(ROUND((a.ADDITIONALCESSAMOUNT) / 100.0, 2), 0) / 100.0
        )
    ) AS TAXABLEVALUE,
    a.SGSTRATE AS SGSTRATE,
    CAST(IFNULL(ROUND(a.SGSTAMOUNT / 100.0, 2), 0) AS VARCHAR(10)) AS SGSTAMOUNT,
    a.CGSTRATE AS CGSTRATE,
    CAST(IFNULL(ROUND(a.CGSTAMOUNT / 100.0, 2), 0) AS VARCHAR(10)) AS CGSTAMOUNT,
    a.IGSTRATE AS IGSTRATE,
    CAST(IFNULL(ROUND(a.IGSTAMOUNT / 100.0, 2), 0) AS VARCHAR(10)) AS IGSTAMOUNT,
    a.CESSRATE AS CESSRATE,
    a.ADDITIONALCESSRATE AS ADDITIONALCESSRATE,
    CAST(IFNULL(ROUND(a.CESSAMOUNT / 100.0, 2), 0) AS VARCHAR(10)) AS CESSAMOUNT,
    CAST(IFNULL(ROUND(a.ADDITIONALCESSAMOUNT / 100.0, 2), 0) AS VARCHAR(10)) AS ADDITIONALCESSAMOUNT,
    IFNULL(a.UOM, '') AS UOM,
    (
        CASE
            WHEN a.UOM IN ('G', 'ML')
            THEN a.QUANTITY / 1000.0
            ELSE a.QUANTITY
        END
    ) AS PCQUANTITY,
    IFNULL(ROUND(a.SALEPRICE / 100.0, 2), 0) AS SALEPRICE,
    a.ISGST AS ISGST,
    a.ISCREDIT AS ISCREDIT,
    a.CUSTOMERPHONE AS CUSTOMERPHONE,
    CASE
        WHEN a.PRODUCTCODE = -1
        THEN '-'
        ELSE a.PRODUCTCODE
    END AS BARCODE,
    a.MEASURE AS MEASURE,
    IFNULL(ROUND(a.MRP / 100.0, 2), 0) AS MRP,
    IFNULL(ROUND(a.BILLITEMDISCOUNT / 100.0, 2), 0) AS BILLITEMDISCOUNT,
    IFNULL(ROUND(a.TOTALAMOUNT / 100.0, 2), 0) AS ITEMTOTALAMOUNT,
    CASE
        WHEN a.ISGST = 1
        THEN NULL
        ELSE a.VATRATE
    END AS ITEMVATRATE,
    CASE
        WHEN a.ISGST = 1
        THEN NULL
        ELSE IFNULL(ROUND(a.VATAMOUNT / 100.0, 2), 0)
    END AS ITEMVATAMOUNT,
    a.TOTALQUANTITY AS TOTALQUANTITY,
    a.TOTALITEMS AS TOTALITEMS,
    IFNULL(ROUND(a.DELIVERYCHARGES / 100.0, 2), 0) AS DELIVERYCHARGES,
    IFNULL(ROUND(a.TOTALAMOUNT / 100.0, 2), 0) AS INVOICETOTALAMOUNT,
    IFNULL(ROUND(a.TOTALVATAMOUNT / 100.0, 2), 0) AS TOTALVATAMOUNT,
    IFNULL(ROUND(a.TOTALSGSTAMOUNT / 100.0, 2), 0) AS TOTALSGSTAMOUNT,
    IFNULL(ROUND(a.TOTALCGSTAMOUNT / 100.0, 2), 0) AS TOTALCGSTAMOUNT,
    IFNULL(ROUND(a.TOTALIGSTAMOUNT / 100.0, 2), 0) AS TOTALIGSTAMOUNT,
    IFNULL(ROUND(a.TOTALCESSAMOUNT / 100.0, 2), 0) AS TOTALCESSAMOUNT,
    IFNULL(ROUND(a.TOTALADDITIONALCESSAMOUNT / 100.0, 2), 0) AS TOTALADDITIONALCESSAMOUNT,
    IFNULL(a.EWAYNUMBER, '') AS EWAYNUMBER,
    IFNULL(paymentMode, '') AS paymentMode,
    IFNULL(ROUND(a.deliveryCharges / 100.0, 2), 0) AS DeliveryAmount,
    IFNULL(ROUND((IFNULL(PA.discountapplied, 0) + a.totalDiscount + a.totalSavings) / 100.0, 2), 0) AS TOTALDISCOUNT,
    IFNULL(amount, 0) AS AmountPaid
FROM
(
    SELECT *
    FROM (
        (
            SELECT
                INVOICES.TOTALSAVINGS,
                INVOICES.BILLTOGSTIN,
                INVOICES.ID,
                Invoices.parentMemoId,
                INVOICES.ISMEMO,
                INVOICES.CREATEDAT,
                INVOICES.NETAMOUNT,
                ITEMS.HSNCODE,
                ITEMS.NAME,
                ITEMS.QUANTITY,
                ITEMS.TOTALAMOUNT,
                ITEMS.SGSTRATE,
                ITEMS.SGSTAMOUNT,
                ITEMS.CGSTRATE,
                ITEMS.CGSTAMOUNT,
                ITEMS.IGSTRATE,
                ITEMS.IGSTAMOUNT,
                ITEMS.CESSRATE,
                ITEMS.CESSAMOUNT,
                ITEMS.ADDITIONALCESSRATE,
                ITEMS.ADDITIONALCESSAMOUNT,
                INVOICES.ISGST,
                INVOICES.ISCREDIT,
                INVOICES.CUSTOMERPHONE,
                IFNULL(Products.userDefinedBarCode, ITEMS.productcode) AS productcode,
                ITEMS.UOM,
                ITEMS.MEASURE,
                ITEMS.MRP,
                ITEMS.SALEPRICE,
                ITEMS.BILLITEMDISCOUNT,
                ITEMS.TOTALAMOUNT,
                ITEMS.VATRATE,
                ITEMS.VATAMOUNT,
                INVOICES.TOTALQUANTITY,
                INVOICES.TOTALITEMS,
                INVOICES.DELIVERYCHARGES,
                INVOICES.TOTALAMOUNT,
                INVOICES.TOTALDISCOUNT,
                INVOICES.TOTALVATAMOUNT,
                INVOICES.TOTALSGSTAMOUNT,
                INVOICES.TOTALCGSTAMOUNT,
                INVOICES.TOTALIGSTAMOUNT,
                INVOICES.TOTALCESSAMOUNT,
                INVOICES.TOTALADDITIONALCESSAMOUNT,
                INVOICES.EWAYNUMBER
            FROM
                INVOICES
            JOIN
                Items
            ON
                INVOICES.ID = ITEMS.INVOICEID
            JOIN
                Products
            ON
                ITEMS.productCode = Products.userDefinedBarCode
            WHERE
                ITEMS.PRODUCTCODE >= 0
                AND INVOICES.ISDELETED = 0
        ) A
        LEFT JOIN (
            SELECT
                invoiceId,
                GROUP_CONCAT(DISTINCT(paymentmode)) AS paymentmode,
                SUM(amount) / 100.00 AS amount
            FROM (
                SELECT
                    invoiceId AS invoiceId,
                    CASE
                        WHEN paymentMode IN ('CASH', 'WALLET', 'CHEQUE', 'Ezetap') THEN paymentMode
                        ELSE transactionType
                    END AS paymentmode,
                    tenderedAmount AS amount
                FROM
                    Transactions
            ) AS SubqueryAlias
            GROUP BY
                invoiceId
            ORDER BY
                invoiceid
        ) B
        ON
            A.ID = B.invoiceId
    ) AB
    LEFT JOIN CuSTOMERS C
    ON
        AB.CUSTOMERPHONE = C.PHONE
) a
LEFT JOIN PromotionsAppliedDetails PA
ON
    A.id = PA.invoiceId
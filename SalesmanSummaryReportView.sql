DROP VIEW IF EXISTS [SalesmanSummaryReportView];
create view IF NOT EXISTS SalesmanSummaryReportView
AS
SELECT DISTINCT(MetadataValues.createdAt),MetadataValues.metadataMappingId, MetadataValues.businessObjectId, 
       MetadataValues.metadataObjectId, MetadataValues.value,Items.id,	   CASE
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
   AS quantity ,Items.totalAmount,Items.invoiceId
	   

	   
FROM Items
INNER JOIN MetadataValues 
ON 
(Case When MetadataValues.businessObjectId=1 THEN
Items.id = CAST(MetadataValues.metadataObjectId as int) 
When MetadataValues.businessObjectId=2 Then
Items.invoiceId =CAST(MetadataValues.metadataObjectId as int) 
END)

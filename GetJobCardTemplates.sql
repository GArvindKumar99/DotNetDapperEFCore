CREATE PROCEDURE [dbo].[GetJobCardTemplates]
	-- Add the parameters for the stored procedure here
	@RoleId int,
	@ModuleId int,
	@StationId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	declare @VendorId int = (select VendorId from Roles where Id = @RoleId)
	
	if @VendorId is not null
	begin
		if @ModuleId is not null and @StationId is not null
		begin
			select * from JobCardTemplates where VendorId = @VendorId and ModuleId = @ModuleId and StationId = @StationId
		end
		else if @ModuleId is not null and @StationId is null
		begin
			select * from JobCardTemplates where VendorId = @VendorId and ModuleId = @ModuleId and StationId is null
		end
		else
		begin
			select * from JobCardTemplates where VendorId = @VendorId
		end
	end
	
END

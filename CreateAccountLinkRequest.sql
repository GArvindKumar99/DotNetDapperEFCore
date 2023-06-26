-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CreateAccountLinkRequest]
	@RoleId int,
	@ParentVendorId int,
	@ChildVendorId int,
	@IsApproved bit,
	@Timestamp bigint
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
declare @VendorId int, @LinkRequestId int = -1

set @VendorId = (select VendorId from Roles where Id = @RoleId)

if @VendorId is not null
begin
	set @LinkRequestId = (select Id from VendorAccountLinks
						where ParentVendorId = @ParentVendorId
						and ChildVendorId = @ChildVendorId)
						
	if @LinkRequestId is null
	begin
		insert into VendorAccountLinks
		values ( @ParentVendorId, @ChildVendorId, @VendorId, @IsApproved,
					null, @Timestamp, null, null)
					
		set @LinkRequestId = CAST(@@IDENTITY as int)
	end
	else
	begin
		update VendorAccountLinks
		set RequestedVendorId = @VendorId,
			IsApproved = @IsApproved,
			IsAccepted = null,
			IsDeleted = null,
			IsDeleteRequested = null,
			[Timestamp] = @Timestamp
		where Id = @LinkRequestId
	end
	
	select * from VendorAccountLinks 
	where Id = @LinkRequestId
end
    
END

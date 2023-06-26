-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CreateServiceCallEvent]
	-- Add the parameters for the stored procedure here
	@RoleId int,
	@ServiceCallId int,
	@DepartmentId int,
	@Content nvarchar(MAX),
	@Timestamp datetime
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @Result bigint
	
    -- Insert statements for procedure here
	insert into ServiceCallEvents
	values (@Timestamp, @RoleId, @Content, @DepartmentId, @ServiceCallId)
	
	set @Result = CAST(@@identity as bigint)
	
	update ServiceCalls
	set EventId = @Result
	where Id = @ServiceCallId
	
	select @Result
END

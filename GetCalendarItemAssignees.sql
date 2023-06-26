﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].GetCalendarItemAssignees
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * 
	from CalendarItemAssignees A, CalendarRoles R, Roles Ro
	where CalendarItemId = @Id and R.RoleId = A.RoleId and R.RoleId = Ro.Id
END
